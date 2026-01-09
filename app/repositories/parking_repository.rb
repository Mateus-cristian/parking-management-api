# frozen_string_literal: true

module Repositories
  class ParkingRepository
    def create(parking_entity)
      parking_entity.save!
      parking_entity
    end

    def find_by_id(id)
      Entities::Parking.find(id)
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end

    def find_history_by_plate(plate)
      Entities::Parking.where(plate: plate).asc(:created_at).to_a
    end

    def update(parking)
      parking.save!
    end

    def find_open_by_plate(plate)
      Entities::Parking.where(plate: plate, left: false).desc(:created_at).first
    end

    def plate_exists?(plate)
      Entities::Parking.where(plate: plate).exists?
    end
  end
end
