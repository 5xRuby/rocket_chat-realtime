# frozen_string_literal: true

require 'rocket_chat/realtime/messages/method'

module RocketChat
  module Realtime
    module Methods
      # Message methods
      #
      # @since 0.1.0
      module Message
        # Login into server
        #
        # @param room_id [String]
        # @param message [String]
        #
        # @since 0.1.0
        def send_message(room_id, message)
          method = Messages::Method.new(
            'sendMessage',
            {
              rid: room_id,
              msg: message
            }
          )
          AsyncTask.start(method.id) do
            driver.text(method.to_json)
          end
        end
      end
    end
  end
end
