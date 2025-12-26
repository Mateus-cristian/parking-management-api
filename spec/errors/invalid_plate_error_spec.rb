# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Errors::InvalidPlateError do
  it 'has status 422 and default message' do
    error = described_class.new
    expect(error.status).to eq(422)
    expect(error.message).to eq('Invalid plate format. Expected AAA-9999')
  end
end
