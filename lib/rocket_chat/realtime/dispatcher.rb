# frozen_string_literal: true

require 'json'
require 'forwardable'

module RocketChat
  module Realtime
    # Message Dispatcher
    #
    # @since 0.1.0
    class Dispatcher
      extend Forwardable

      # @since 0.1.0
      HANDLERS = {
        # TODO
      }.freeze

      # @since 0.1.0
      delegate %w[logger] => RocketChat::Realtime

      # @since 0.1.0
      attr_reader :driver, :event

      # @param driver [WebSocket::Driver::Client]
      # @param event [RocketChat::Realtime::EventManager]
      #
      # @since 0.1.0
      def initialize(driver, event)
        @driver = driver
        @event = event

        driver.on(:message, &method(:dispatch))
      end

      # Dispatch messages
      #
      # @param event [WebSocket::Driver::MessageEvent]
      #
      # @return [Boolean] is dispatched
      #
      # @since 0.1.0
      def dispatch(event)
        message = JSON.parse(event.data)
        handler = HANDLERS[message.fetch('msg', nil)]
        if handler
          handler.new(event).perform
        else
          logger.debug("No handler found for - #{message}")
          false
        end
      rescue JSON::ParserError
        # nope
      end
    end
  end
end
