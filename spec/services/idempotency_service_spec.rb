# frozen_string_literal: true

require 'spec_helper'

describe Services::IdempotencyService do
  let(:repo) { double('IdempotencyRepository') }
  let(:service) { described_class.new(repo) }

  it 'returns existing result if key already exists' do
    expect(repo).to receive(:find).with('key').and_return('result')
    expect(service.execute('key') { 'new' }).to eq('result')
  end

  it 'executes block and saves if key does not exist' do
    expect(repo).to receive(:find).with('key').and_return(nil)
    expect(repo).to receive(:create).with('key', 'new').and_return('new')
    expect(service.execute('key') { 'new' }).to eq('new')
  end

  it 'raises error if key is missing' do
    expect { service.execute(nil) { 'x' } }.to raise_error(Errors::BaseError)
  end
end
