# frozen_string_literal: true

require 'singleton'
require 'forwardable'

require 'nio'

module RocketChat
  module Realtime
    # The scheduler manager
    #
    # @since 0.1.0
    class Reactor
      class << self
        extend Forwardable

        # @since 0.1.0
        delegate %w[
          selector
          register
          registered?
          clients
        ] => :instance
      end

      include Singleton

      # @since 0.1.0
      attr_reader :selector, :clients

      # Initialize Reactor
      #
      # @since 0.1.0
      def initialize
        @selector = NIO::Selector.new
        @clients = Set.new
      end

      # The client is registered
      #
      # @param client [Rocket::Realtime::Client]
      #
      # @return [Boolean]
      #
      # @since 0.1.0
      def registered?(client)
        @clients.include?(client)
      end

      # Register Client
      #
      # @param client [RocketChat::Realtime::Client]
      #
      # @since 0.1.0
      def register(client)
        return if registered?(client)

        @clients.add(client)
        monitor = selector.register(client.connector.socket, :rw)
        monitor.value = client
      end
    end
  end
end
