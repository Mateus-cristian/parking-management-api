# frozen_string_literal: true

require_relative '../errors/base_error'

module ErrorHandlers
  def self.registered(app)
    app.error Errors::BaseError do |error|
      content_type :json
      status error.status

      {
        error: error.message
      }.to_json
    end

    app.error StandardError do |_error|
      content_type :json
      status 500

      {
        error: 'Internal server error'
      }.to_json
    end
  end
end
