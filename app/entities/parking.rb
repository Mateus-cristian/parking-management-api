# frozen_string_literal: true

module Entities
  class Parking
    attr_accessor :id, :plate, :paid, :left, :created_at, :paid_at, :left_at

    def initialize(attrs = {})
      @id         = attrs[:id]
      @plate      = attrs[:plate]
      @paid       = attrs[:paid] || false
      @left       = attrs[:left] || false
      @created_at = attrs[:created_at] || Time.now
      @paid_at    = attrs[:paid_at]
      @left_at    = attrs[:left_at]
    end

    def mark_as_left
      raise Errors::NotPaidError unless paid
      return if left

      @left = true
      @left_at = Time.now
    end

    def self.from_document(doc)
      return nil unless doc

      new(
        id: doc['_id'].to_s,
        plate: doc['plate'],
        paid: !!doc['paid'],
        left: !!doc['left'],
        created_at: doc['created_at'],
        paid_at: doc['paid_at'],
        left_at: doc['left_at']
      )
    end

    def to_hash
      {
        id: id,
        plate: plate,
        paid: paid,
        left: left,
        created_at: created_at,
        paid_at: paid_at,
        left_at: left_at
      }
    end

    def to_json(*_args)
      to_hash.to_json
    end
  end
end
