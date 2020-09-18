# frozen_string_literal: true

require 'rocket_chat/realtime/handlers/base'

module RocketChat
  module Realtime
    module Handlers
      # Base Message Handler
      #
      # @since 0.1.0
      class Base
        class << self
          # Dispatch message
          #
          # @param dispatcher [RocketChat::Realtime::Dispatcher]
          # @param message [Hash] the message from server
          #
          # @since 0.1.0
          def call(dispatcher, message)
            new(dispatcher, message).process
          end
        end

        # @since 0.1.0
        attr_reader :dispatcher, :message

        # @param dispatcher [RocketChat::Realtime::Dispatcher]
        # @param message [Hash] the message from server
        #
        # @since 0.1.0
        def initialize(dispatcher, message)
          @dispatcher = dispatcher
          @message = message
        end

        # Process message
        #
        # @since 0.1.0
        def process
          raise NotImplementedError
        end
      end
    end
  end
end
