# frozen_string_literal: true

require 'rocket_chat/realtime/handlers/base'
require 'rocket_chat/realtime/messages/changed'

module RocketChat
  module Realtime
    module Handlers
      # Changed Message Handler
      #
      # The DDP Subscribe changed event
      #
      # @since 0.1.0
      class Changed < Base
        # Changed
        #
        # @return [RocketChat::Realtime::Messages::Changed]
        #
        # @since 0.1.0
        def changed
          Messages::Changed.new(message['id'], message)
        end

        # @see RocketChat::Realtime::Handlers::Base#process
        def process
          client.emit(changed.collection, changed)
        end
      end
    end
  end
end
