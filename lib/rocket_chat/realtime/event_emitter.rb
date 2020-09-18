# frozen_string_literal: true

require 'concurrent'

module RocketChat
  module Realtime
    # Provide event listener support
    #
    # @since 0.1.0
    module EventEmitter
      # Register event listener
      #
      # @param event [String] event name
      # @param callback [Proc] event handler
      #
      # @since 0.1.0
      def on(event, &callback)
        listeners.compute(event.to_s) do |current|
          current ||= []
          current.push(callback)
          current
        end
      end

      # Deregister event listener
      #
      # @param event [String] event name
      # @param callback [Proc] callback to remove
      #
      # @since 0.1.0
      def off(event, &callback)
        listeners.compute(event.to_s) do |current|
          current ||= []
          current.delete(callback)
          return nil if current.empty?

          current
        end
      end

      # Publish event
      #
      # @param event [String] event name
      # @param data [Object] event to publish
      #
      # @since 0.1.0
      def emit(event, data)
        listeners[event.to_s]&.each do |listener|
          listener.call(data)
        end
      end

      protected

      # Event Listeners
      #
      # @return [Concurrent::Map]
      #
      # @since 0.1.0
      def listeners
        @listeners ||= Concurrent::Map.new
      end
    end
  end
end
