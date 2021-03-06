# frozen_string_literal: true

require 'rocket_chat/realtime/message'

module RocketChat
  module Realtime
    module Messages
      # The result message
      #
      # The DDP RPC result message
      #
      # @since 0.1.0
      class Result < Message
        # @since 0.1.0
        attr_reader :result

        # @param args [Array] the parameters for method
        def initialize(id, result)
          super('result', id)

          @result = result
        end

        # @see RocketChat::Realtime::Message#body
        #
        # @since 0.1.0
        def body
          {
            result: result
          }
        end

        # :nodoc:
        def [](key)
          result.fetch(key.to_s, nil)
        end
      end
    end
  end
end
