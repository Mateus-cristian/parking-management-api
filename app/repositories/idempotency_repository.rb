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
      serializable_data =
        if data.respond_to?(:to_hash)
          data.to_hash
        else
          data
        end
      @collection.insert_one(
        idempotency_key: key,
        data: serializable_data,
        created_at: Time.now
      )
      data
    end
  end
end
