# frozen_string_literal: true

require 'rocket_chat/realtime/message'

module RocketChat
  module Realtime
    module Messages
      # The method message
      #
      # The DDP RPC method call
      #
      # @since 0.1.0
      class Method < Message
        # @since 0.1.0
        attr_reader :name, :parameters

        # @param args [Array] the parameters for method
        def initialize(name, *parameters)
          super('method')

          @name = name
          @parameters = parameters
        end

        # @see RocketChat::Realtime::Message#body
        #
        # @since 0.1.0
        def body
          {
            method: name,
            params: parameters
          }
        end
      end
    end
  end
end
