# frozen_string_literal: true

require 'rocket_chat/realtime/handlers/base'

module RocketChat
  module Realtime
    module Handlers
      # Ready Message Handler
      #
      # The DDP Subscribe success event
      #
      # @since 0.1.0
      class Ready < Base
        # @see RocketChat::Realtime::Handlers::Base#process
        def process
          message['subs']&.each do |id|
            AsyncTask.resolve(id)
          end
        end
      end
    end
  end
end
