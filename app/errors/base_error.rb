# frozen_string_literal: true

module Errors
  class BaseError < StandardError
    attr_reader :status

    def initialize(message:, status:)
      @status = status
      super(message)
    end
  end
end
