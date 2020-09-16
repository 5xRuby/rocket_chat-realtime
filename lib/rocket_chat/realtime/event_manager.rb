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

        driver.on(:error) { |event| logger.error(event.message) }
        driver.on(:message) { |event| dispatch(event) }

        register_connection_event
        register_heartbeat_event
      end

      # Dispatch event to listeners
      #
      # @param event [WebSocket::Driver::MessageEvent]
      #
      # @since 0.1.0
      def dispatch(event)
        # TODO: Move handler to standalone class
        message = JSON.parse(event.data)
        handler = "process_#{message['msg']}"
        send(handler, message) if respond_to?(handler)
      rescue JSON::ParserError => e
        logger.error(e.message)
      end

      # Ping handler
      #
      # @param message [Hash]
      #
      # @since 0.1.0
      def process_ping(_message)
        driver.text({ msg: 'pong' }.to_json)
      end

      # Result handler
      #
      # @param message [Hash]
      #
      # @since 0.1.0
      def process_result(message)
        # TODO
        logger.debug(message)
      end

      private

      # Register Connection Event
      #
      # @since 0.1.0
      def register_connection_event
        # TODO: Add Client identity to log
        driver.on(:open) { |_event| logger.info('Client is connected') }
        driver.on(:close) { |event| logger.info("Client is closed due to #{event.reason}") }
      end

      # Register Heartbeat Event
      #
      # @since 0.1.0
      def register_heartbeat_event
        driver.on :pong do |event|
          unless event.data.empty?
            start_time = Time.at(event.data.to_f)
            ttl = ((Time.now - start_time).to_f * 1000).round(4)
            logger.info("Heartbeat TTL: #{ttl}ms")
          end
        end
      end
    end
  end
end
