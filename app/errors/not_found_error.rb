# frozen_string_literal: true

require_relative 'base_error'

module Errors
  class NotFoundError < BaseError
    def initialize
      super(message: 'Resource not found', status: 404)
    end
  end
end
