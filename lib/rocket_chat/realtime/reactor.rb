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
        delegate %w[selector] => :instance
      end

      include Singleton

      # @since 0.1.0
      attr_reader :selector

      # Initialize Reactor
      #
      # @since 0.1.0
      def initialize
        @selector = NIO::Selector.new
      end
    end
  end
end
