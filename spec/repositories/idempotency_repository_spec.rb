# frozen_string_literal: true

require 'spec_helper'

describe Repositories::IdempotencyRepository do
  let(:mongo_client) { double('MongoClient') }
  let(:collection) { double('Collection') }
  let(:repo) { described_class.new(mongo_client) }

  before do
    allow(mongo_client).to receive(:[]).and_return(collection)
  end

  it 'finds existing key' do
    expect(collection)
      .to receive(:find)
      .with(idempotency_key: 'key')
      .and_return([{ 'data' => 'result' }])
    expect(repo.find('key')).to eq('result')
  end

  it 'returns nil if not found' do
    expect(collection).to receive(:find).with(idempotency_key: 'key').and_return([])
    expect(repo.find('key')).to be_nil
  end

  it 'creates key' do
    expect(collection).to receive(:insert_one).with(hash_including(idempotency_key: 'key',
                                                                   data: 'result'))
    expect(repo.create('key', 'result')).to eq('result')
  end
end
