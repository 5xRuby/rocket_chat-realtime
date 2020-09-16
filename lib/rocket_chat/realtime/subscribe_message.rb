# frozen_string_literal: true

require 'rocket_chat/realtime/message'

module RocketChat
  module Realtime
    # The subscribe message
    #
    # @since 0.1.0
    class SubscribeMessage < Message
      # @since 0.1.0
      attr_reader :name, :parameters

      # @param args [Array] the parameters for method
      def initialize(name, *parameters)
        super('sub')

        @name = name
        @parameters = parameters
      end

      # @see RocketChat::Realtime::Message#body
      #
      # @since 0.1.0
      def body
        {
          name: name,
          params: parameters
        }
      end
    end
  end
end
