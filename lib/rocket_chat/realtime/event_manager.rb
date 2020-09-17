# frozen_string_literal: true

require 'forwardable'

module RocketChat
  module Realtime
    # Manage events from WebSocket
    #
    # @since 0.1.0
    class EventManager
      extend Forwardable

      # @since 0.1.0
      delegate %w[logger] => RocketChat::Realtime

      # @sicne 0.1.0
      attr_reader :driver

      # @param driver [WebSocket::Driver::Client]
      #
      # @since 0.1.0
      def initialize(driver)
        @driver = driver

        # TODO: Move to dispatcher or client
        driver.on(:open) { |_event| logger.info('Client is connected') }
        driver.on(:close) { |event| logger.info("Client is closed due to #{event.reason}") }
        driver.on(:error) { |event| logger.error(event.message) }
      end
    end
  end
end
