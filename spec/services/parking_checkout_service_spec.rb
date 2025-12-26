# frozen_string_literal: true

require 'spec_helper'

describe Services::ParkingCheckoutService do
  let(:repo) { double('ParkingRepository') }
  let(:idempotency_service) { double('IdempotencyService') }
  let(:service) { described_class.new(repo, idempotency_service) }

  describe '#call' do
    let(:parking_doc) do
      build(:parking,
            id: '507f1f77bcf86cd799439011',
            plate: 'CHK-1234',
            paid: true,
            left: false)
    end
    let(:unpaid_doc) do
      build(:parking,
            id: '507f1f77bcf86cd799439012',
            plate: 'CHK-9999',
            paid: false,
            left: false)
    end

    it 'marks as left if paid' do
      expect(repo).to receive(:find_by_id).with('507f1f77bcf86cd799439011').and_return(parking_doc)
      expect(idempotency_service).to receive(:execute).with('key1').and_yield
      expect(repo).to receive(:update) do |parking|
        expect(parking.left).to eq(true)
        expect(parking.left_at).not_to be_nil
      end
      service.call(id: '507f1f77bcf86cd799439011', idempotency_key: 'key1')
    end

    it 'raises error if not paid' do
      expect(repo).to receive(:find_by_id).with('507f1f77bcf86cd799439012').and_return(unpaid_doc)
      allow(idempotency_service).to receive(:execute)
      expect(repo).not_to receive(:update)
      expect do
        service.call(id: '507f1f77bcf86cd799439012', idempotency_key: 'key2')
      end.to raise_error(Errors::NotPaidError)
    end

    it 'raises error if not found' do
      expect(repo).to receive(:find_by_id).with('000000000000000000000000').and_return(nil)
      expect(idempotency_service).not_to receive(:execute)
      expect do
        service.call(id: '000000000000000000000000', idempotency_key: 'key3')
      end.to raise_error(Errors::NotFoundError)
    end
  end
end
