# frozen_string_literal: true

module Repositories
  class IdempotencyRepository
    COLLECTION = :idempotency_keys

    def initialize(client = MongoClient.client)
      @collection = client[COLLECTION]
    end

    def find(key)
      doc = @collection.find(idempotency_key: key).first
      doc ? doc['data'] : nil
    end

    def create(key, data)
      @collection.insert_one(
        idempotency_key: key,
        data: data,
        created_at: Time.now
      )
      data
    end
  end
end
