# frozen_string_literal: true

require 'websocket/driver'

module RocketChat
  module Realtime
    # Rocket.Chat Reamtime API
    #
    # @since 0.1.0
    class Client
      # @since 0.1.0
      attr_reader :server

      # @param options [Hash]
      #
      # @since 0.1.0
      def initialize(options = {})
        @server = options[:server]
      end

      # @return [String] the realtime api endpoint
      #
      # @since 0.1.0
      def endpoint
        "#{server}/websocket"
      end

      # @return [RocketChat::Realtime::Connector]
      #
      # @since 0.1.0
      def connector
        @connector ||= Connector.new(endpoint)
      end

      # @return [RocketChat::Realtime::Adapter]
      #
      # @since 0.1.0
      def adapter
        @adapter ||= Adapter.new(endpoint)
      end

      # @return [WebSocket::Driver::Client]
      #
      # @since 0.1.0
      def driver
        @driver ||= WebSocket::Driver.client(adapter)
      end

      # Connect to server
      #
      # @since 0.1.0
      def connect
        driver.start
        Reactor.register(self)
      end

      # Close connection to server
      #
      # @since 0.1.0
      def disconnect
        driver.close
        Reactor.deregister(self)
      end

      # Process I/O
      #
      # @param monitor [NIO::Monitor]
      #
      # @since 0.1.0
      def process(monitor)
        driver.parse(monitor.io.read_nonblock(2**14)) if monitor.readable?
        adapter.pump_buffer(monitor.io) if monitor.writeable?
      rescue EOFError
        monitor.close
        disconnect
      end
    end
  end
end
