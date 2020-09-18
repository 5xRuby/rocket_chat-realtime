# frozen_string_literal: true

require 'digest'

module RocketChat
  module Realtime
    module Methods
      # Auth methods
      #
      # @since 0.1.0
      module Auth
        # Login into server
        #
        # @param username [String]
        # @param password [String]
        #
        # @since 0.1.0
        def login(username, password)
          method = MethodMessage.new(
            'login',
            user: { username: username },
            password: { algorithm: 'sha-256', digest: Digest::SHA256.hexdigest(password) }
          )
          AsyncTask.start(method.id) do
            driver.text(method.to_json)
          end
        end
      end
    end
  end
end
