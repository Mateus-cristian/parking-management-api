# frozen_string_literal: true

require 'mongo'

module Repositories
  class MongoClient
    def self.client
      @client ||= Mongo::Client.new(
        ENV.fetch('MONGO_URL'),
        server_selection_timeout: 5
      )
    end
  end
end
