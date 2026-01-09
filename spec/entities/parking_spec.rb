# frozen_string_literal: true

require 'spec_helper'
require 'factory_bot'

describe Entities::Parking do
  include FactoryBot::Syntax::Methods

  before(:each) { Entities::Parking.delete_all }

  it 'initializes correctly' do
    parking = build(:parking)
    expect(parking.plate).to eq('ABC-1234')
    expect(parking.paid).to be false
  end

  it 'converts to hash' do
    parking = build(:parking)
    expect(parking.to_hash[:plate]).to eq('ABC-1234')
  end

  it 'converts to json' do
    parking = build(:parking)
    expect(JSON.parse(parking.to_json)['plate']).to eq('ABC-1234')
  end

  it 'creates from document' do
    doc = {
      plate: 'ABC-1234',
      paid: false,
      left: false,
      created_at: Time.now,
      paid_at: nil,
      left_at: nil
    }
    parking = Entities::Parking.new(doc)
    expect(parking.plate).to eq('ABC-1234')
  end
end
