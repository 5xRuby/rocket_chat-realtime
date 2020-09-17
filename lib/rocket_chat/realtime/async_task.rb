# frozen_string_literal: true

require 'singleton'
require 'forwardable'

require 'concurrent'

module RocketChat
  module Realtime
    # AsyncTask resolver
    #
    # @since 0.1.0
    class AsyncTask
      class << self
        extend Forwardable

        delegate %w[start resolve] => :instance
      end

      include Singleton
      include Concurrent::Promises::FactoryMethods

      # @since 0.1.0
      def initialize
        @tasks = Concurrent::Map.new
      end

      # Register a new task
      #
      # @param id [String] task id
      # @param block [Proc] task body
      #
      # @return [Concurrent::Promises::ResolvableFuture]
      #
      # @since 0.1.0
      def start(id)
        # TODO: check for atomic
        @tasks.fetch_or_store(id, resolvable_future)
      end

      # Resolve task
      #
      # @param result [RocketChat::Realtime::ReslutMessage]
      #
      # @return [Concurrent::Promises::ResolvableFuture]
      #
      # @since 0.1.0
      def resolve(id, result)
        task = @tasks.delete(id)
        task&.fulfill result
        task
      end
    end
  end
end
