# frozen_string_literal: true

require_relative 'base_error'

module Errors
  class CarAlreadyInParkingError < BaseError
    def initialize(msg = 'Car is already in the parking lot')
      super(message: msg, status: 409)
    end
  end
end
