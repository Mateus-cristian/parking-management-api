# frozen_string_literal: true

require 'spec_helper'

describe Errors::NotFoundError do
  it 'inherits from BaseError' do
    expect(described_class.superclass).to eq(Errors::BaseError)
  end

  it 'has correct message and status' do
    error = described_class.new
    expect(error.message).to eq('Resource not found')
    expect(error.status).to eq(404)
  end
end
