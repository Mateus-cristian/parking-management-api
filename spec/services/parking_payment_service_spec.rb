# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Services::ParkingPaymentService do
  let(:repo) { instance_double(Repositories::ParkingRepository) }
  let(:idempotency_service) { instance_double(Services::IdempotencyService) }
  let(:service) { described_class.new(repo, idempotency_service) }

  let(:parking) do
    Entities::Parking.new(id: '507f1f77bcf86cd799439011', plate: 'ABC-1234', paid: false,
                          left: false)
  end

  before(:each) { Entities::Parking.delete_all }

  describe '#call' do
    it 'marks as paid and updates parking' do
      expect(repo).to receive(:find_by_id).with('507f1f77bcf86cd799439011').and_return(parking)
      expect(idempotency_service).to receive(:execute).with('key1').and_yield
      expect(repo).to receive(:update) do |entity|
        expect(entity.paid).to eq(true)
        expect(entity.paid_at).not_to be_nil
      end
      service.call(id: '507f1f77bcf86cd799439011', idempotency_key: 'key1')
    end

    it 'raises error if not found' do
      expect(repo).to receive(:find_by_id).with('notfound').and_return(nil)
      expect do
        service.call(id: 'notfound', idempotency_key: 'key2')
      end.to raise_error(Errors::NotFoundError)
    end

    it 'does not update if already paid' do
      paid_parking = Entities::Parking.new(id: '507f1f77bcf86cd799439012', plate: 'ABC-9999',
                                           paid: true, left: false)
      expect(repo).to receive(:find_by_id).with('507f1f77bcf86cd799439012').and_return(paid_parking)
      expect(idempotency_service).to receive(:execute).with('key3').and_yield
      expect(repo).to receive(:update) do |entity|
        expect(entity.paid).to eq(true)
      end
      expect do
        service.call(id: '507f1f77bcf86cd799439012', idempotency_key: 'key3')
      end.not_to raise_error
    end
  end
end
