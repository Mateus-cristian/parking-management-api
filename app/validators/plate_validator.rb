# frozen_string_literal: true

module Validators
  class PlateValidator
    REGEX = /^[A-Z]{3}-\d{4}$/

    def self.validate!(plate)
      normalized = plate.to_s.strip.upcase
      raise Errors::InvalidPlateError unless normalized.match?(REGEX)

      normalized
    end
  end
end
