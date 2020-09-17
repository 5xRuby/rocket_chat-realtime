# frozen_string_literal: true

require 'forwardable'
require 'json'

require 'websocket/driver'

require 'rocket_chat/realtime/methods/auth'
require 'rocket_chat/realtime/subscriptions/room'

module RocketChat
  module Realtime
    # Rocket.Chat Reamtime API
    #
    # @since 0.1.0
    class Client
      extend Forwardable

      include Methods::Auth
      include Subscriptions::Room

      # @since 0.1.0
      INITIALIZE_COMMAND = {
        msg: :connect,
        version: '1',
        support: ['1']
      }.freeze

      # @since 0.1.0
      delegate %w[ping pong] => :driver

      # @since 0.1.0
      attr_reader :server, :connector, :adapter, :driver, :event

      # @param options [Hash]
      #
      # @since 0.1.0
      def initialize(options = {})
        @server = options[:server]
        init_connection
        init_events
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
        driver.text(INITIALIZE_COMMAND.to_json)
        Reactor.register(self)
      end

      # Close connection to server
      #
      # @since 0.1.0
      def disconnect
        driver.close
        Reactor.deregister(self)
      end

      # WebSocket is opened
      #
      # @return [Boolean] open or not
      #
      # @since 0.1.0
      def opened?
        driver.state == :open
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

      private

      # Prepare for connection
      #
      # @since 0.1.0
      def init_connection
        @connector = Connector.new(endpoint)
        @adapter = Adapter.new(endpoint)
        @driver = WebSocket::Driver.client(adapter)
      end

      # Prepare for events
      #
      # @since 0.1.0
      def init_events
        @event = EventManager.new(driver)
        @dispatcher = Dispatcher.new(driver, event)
      end
    end
  end
end
