# frozen_string_literal: true

module Services
  class ParkingPaymentService
    def initialize(
      parking_repo = Repositories::ParkingRepository.new,
      idempotency_service = Services::IdempotencyService.new
    )
      @parking_repo = parking_repo
      @idempotency_service = idempotency_service
    end

    def call(id:, idempotency_key:)
      parking_entity = @parking_repo.find_by_id(id)
      raise Errors::NotFoundError unless parking_entity

      parking_entity.mark_as_paid

      @idempotency_service.execute(idempotency_key) do
        @parking_repo.update(parking_entity)
        parking_entity
      end
    end
  end
end
