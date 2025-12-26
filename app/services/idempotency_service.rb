# frozen_string_literal: true

module Services
  class IdempotencyService
    def initialize(repository = Repositories::IdempotencyRepository.new)
      @repository = repository
    end

    def execute(key)
      raise Errors::BaseError.new(message: 'Idempotency key missing', status: 400) unless key

      existing = @repository.find(key)
      return existing if existing

      result = yield
      @repository.create(key, result)
      result
    end
  end
end
