# frozen_string_literal: true

require 'rocket_chat/realtime/handlers/base'

module RocketChat
  module Realtime
    module Handlers
      # Changed Message Handler
      #
      # The DDP Subscribe changed event
      #
      # @since 0.1.0
      class Changed < Base
        # @see RocketChat::Realtime::Handlers::Base#process
        def process
          client.emit(message['collection'], message)
        end
      end
    end
  end
end
