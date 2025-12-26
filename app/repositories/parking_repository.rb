# frozen_string_literal: true

module Repositories
  class ParkingRepository
    COLLECTION = :parkings

    def initialize(client = MongoClient.client)
      @collection = client[COLLECTION]
    end

    def create(parking_entity)
      attrs = parking_entity.to_hash.reject { |k| k == :id }
      result = @collection.insert_one(attrs)
      parking_entity.id = result.inserted_id.to_s
      parking_entity
    end

    def find_by_id(id)
      doc = @collection.find(_id: BSON::ObjectId.from_string(id)).first
      Entities::Parking.from_document(doc)
    rescue BSON::Error::InvalidObjectId
      nil
    end

    def update(parking)
      id = parking.id
      attrs = parking.to_hash.reject { |k| k == :id }

      @collection.update_one(
        { _id: BSON::ObjectId.from_string(id) },
        { '$set' => attrs }
      )
    end
  end
end
