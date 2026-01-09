# frozen_string_literal: true

module Entities
  class Parking
    include Mongoid::Document
    include Mongoid::Timestamps

    field :plate, type: String
    field :paid, type: Boolean, default: false
    field :left, type: Boolean, default: false
    field :paid_at, type: Time
    field :left_at, type: Time

    def mark_as_left
      raise Errors::NotPaidError unless paid
      return if left

      self.left = true
      self.left_at = Time.now
      save!
    end

    def mark_as_paid
      return if paid

      self.paid = true
      self.paid_at = Time.now
      save!
    end

    def to_hash
      {
        id: id.to_s,
        plate: plate,
        paid: paid,
        left: left,
        created_at: created_at,
        paid_at: paid_at,
        left_at: left_at
      }
    end
  end
end
