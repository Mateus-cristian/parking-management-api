# frozen_string_literal: true

require 'spec_helper'

describe Services::ParkingEntryService do
  let(:repo) { double('ParkingRepository') }
  let(:idempotency_service) { double('IdempotencyService') }
  let(:service) { described_class.new(repo, idempotency_service) }

  it 'creates parking with valid plate' do
    expect(Validators::PlateValidator)
      .to receive(:validate!)
      .with('ABC-1234')
      .and_return('ABC-1234')
    expect(idempotency_service).to receive(:execute).with('key').and_yield
    parking = double('Parking', to_hash: { plate: 'ABC-1234' })
    expect(repo).to receive(:create).and_return(parking)
    expect(service.call(plate: 'ABC-1234', idempotency_key: 'key')).to eq({ plate: 'ABC-1234' })
  end

  it 'raises error if plate is invalid' do
    expect(Validators::PlateValidator).to receive(:validate!).and_raise(Errors::InvalidPlateError)
    expect { service.call(plate: 'XXX', idempotency_key: 'key') }.to raise_error(Errors::InvalidPlateError)
  end
end
