# frozen_string_literal: true

require 'rocket_chat/realtime/handlers/base'
require 'rocket_chat/realtime/messages/result'

module RocketChat
  module Realtime
    module Handlers
      # Result Message Handler
      #
      # The DDP RPC return value
      #
      # @since 0.1.0
      class Result < Base
        # The message result
        #
        # @return [RocketChat::Realtime::Messages::Result]
        #
        # @since 0.1.0
        def result
          Messages::Result.new(
            message['id'],
            message['result']
          )
        end

        # @see RocketChat::Realtime::Handlers::Base#process
        def process
          AsyncTask.resolve(result.id, result)
        end
      end
    end
  end
end
