# frozen_string_literal: true

require 'forwardable'
require 'websocket/driver'

module RocketChat
  module Realtime
    # Rocket.Chat Reamtime API
    #
    # @since 0.1.0
    class Client
      extend Forwardable

      # @since 0.1.0
      delegate %w[ping pong] => :driver

      # @since 0.1.0
      attr_reader :server, :connector, :adapter, :driver, :event

      # @param options [Hash]
      #
      # @since 0.1.0
      def initialize(options = {})
        @server = options[:server]
        @connector = Connector.new(endpoint)
        @adapter = Adapter.new(endpoint)
        @driver = WebSocket::Driver.client(adapter)
        @event = EventManager.new(driver)
      end

      # @return [String] the realtime api endpoint
      #
      # @since 0.1.0
      def endpoint
        "#{server}/websocket"
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
      rescue IO::WaitReadable, IO::WaitWritable
        # nope
      rescue Errno::ECONNRESET, EOFError, Errno::ECONNABORTED
        RocketChat::Realtime.logger.warn('Remote server is closed.')
        monitor.close
        disconnect
      end
    end
  end
end
