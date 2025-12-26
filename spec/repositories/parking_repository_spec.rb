# frozen_string_literal: true

require 'spec_helper'

describe Repositories::ParkingRepository do
  let(:mongo_client) { double('MongoClient') }
  let(:collection) { double('Collection') }
  let(:repo) { described_class.new(mongo_client) }
  let(:valid_id) { '507f1f77bcf86cd799439011' }

  before do
    allow(mongo_client).to receive(:[]).and_return(collection)
  end

  it 'creates a parking' do
    parking = double('Parking', to_hash: { plate: 'ABC-1234' }, id: nil)
    expect(collection).to receive(:insert_one).and_return(double(inserted_id: valid_id))
    expect(parking).to receive(:id=).with(valid_id)
    repo.create(parking)
  end

  it 'finds by id' do
    doc = { '_id' => valid_id, 'plate' => 'ABC-1234' }
    expect(collection).to receive(:find).with(_id: anything).and_return([doc])
    expect(Entities::Parking).to receive(:from_document).with(doc)
    repo.find_by_id(valid_id)
  end

  it 'updates a parking' do
    parking = double('Parking', id: valid_id,
                                to_hash: {
                                  id: valid_id,
                                  plate: 'XYZ-9999',
                                  left: true,
                                  paid: true
                                })

    expect(collection).to receive(:update_one).with(
      { _id: BSON::ObjectId.from_string(valid_id) },
      { '$set' => { plate: 'XYZ-9999', left: true, paid: true } }
    )
    repo.update(parking)
  end
end
