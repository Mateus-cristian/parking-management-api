# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Errors::CarAlreadyInParking do
  it 'has status 409 and default message' do
    error = described_class.new
    expect(error.status).to eq(409)
    expect(error.message).to eq('Car is already in the parking lot')
  end
end
