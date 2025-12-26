# frozen_string_literal: true

require_relative 'base_error'

module Errors
  class NotPaidError < BaseError
    def initialize
      super(message: 'Payment required before checkout', status: 400)
    end
  end
end
