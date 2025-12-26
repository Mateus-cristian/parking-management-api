# frozen_string_literal: true

require_relative 'base_error'

module Errors
  class InvalidPlateError < BaseError
    def initialize
      super(message: 'Invalid plate format. Expected AAA-9999', status: 422)
    end
  end
end
