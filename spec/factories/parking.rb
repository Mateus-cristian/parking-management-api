# frozen_string_literal: true

FactoryBot.define do
  factory :parking, class: Entities::Parking do
    id { '507f1f77bcf86cd799439011' }
    plate { 'ABC-1234' }
    paid { false }
    left { false }
    created_at { Time.now }
    paid_at { nil }
    left_at { nil }
  end
end
