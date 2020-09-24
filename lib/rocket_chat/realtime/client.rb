# frozen_string_literal: true

require 'forwardable'
require 'json'

require 'websocket/driver'

require 'rocket_chat/realtime/methods/auth'
require 'rocket_chat/realtime/methods/message'
require 'rocket_chat/realtime/subscriptions/room'

module RocketChat
  module Realtime
    # Rocket.Chat Reamtime API
    #
    # @since 0.1.0
    class Client
      extend Forwardable

      include EventEmitter
      include Methods::Auth
      include Methods::Message
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
      attr_reader :server, :connector, :adapter, :driver, :dispatcher

      # @param options [Hash]
      #
      # @since 0.1.0
      def initialize(options = {})
        @server = options[:server]
        @connector = Connector.new(endpoint)
      end

      # @return [String] the realtime api endpoint
      #
      # @since 0.1.0
      def endpoint
        "#{server}/websocket"
      end

      # Add to reactor
      #
      # @since 0.1.0
      def add_to_reactor
        monitor = Reactor.register(self)
        return if monitor.nil?

        @adapter = Adapter.new(endpoint, monitor)
        @driver = WebSocket::Driver.client(adapter)
        @dispatcher = Dispatcher.new(self)
      end

      # Connect to server
      #
      # @since 0.1.0
      def connect
        add_to_reactor
        driver.start
        driver.text(INITIALIZE_COMMAND.to_json)
      end

      # Close connection to server
      #
      # @since 0.1.0
      def disconnect
        @adapter.dispose
        @dispatcher.dispose
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
        monitor.interests = adapter.pending? ? :rw : :r
        driver.parse(monitor.io.read_nonblock(2**14)) if monitor.readable?
        adapter.pump_buffer if monitor.writeable?
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
