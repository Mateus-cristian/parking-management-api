# frozen_string_literal: true

require 'spec_helper'

describe Repositories::ParkingRepository do
  let(:repo) { described_class.new }

  before do
    Entities::Parking.delete_all
  end

  it 'creates a parking' do
    parking = Entities::Parking.new(plate: 'ABC-1234')
    expect { repo.create(parking) }.to change { Entities::Parking.count }.by(1)
    expect(parking.id).not_to be_nil
  end

  it 'finds by id' do
    parking = Entities::Parking.create!(plate: 'ABC-1234')
    found = repo.find_by_id(parking.id)
    expect(found).to be_a(Entities::Parking)
    expect(found.plate).to eq('ABC-1234')
  end

  it 'updates a parking' do
    parking = Entities::Parking.create!(plate: 'XYZ-9999', left: false, paid: false)
    parking.left = true
    parking.paid = true
    repo.update(parking)
    updated = Entities::Parking.find(parking.id)
    expect(updated.left).to be true
    expect(updated.paid).to be true
  end
end
