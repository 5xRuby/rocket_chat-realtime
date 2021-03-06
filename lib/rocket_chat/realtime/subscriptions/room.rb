# frozen_string_literal: true

require 'rocket_chat/realtime/messages/subscribe'

module RocketChat
  module Realtime
    module Subscriptions
      # Room Subscriptions
      #
      # @since 0.1.0
      module Room
        # Subscribe to room messages
        #
        # @param room_id [String]
        #
        # @since 0.1.0
        def subscribe_room_messages(room_id)
          subscription = Messages::Subscribe.new(
            'stream-room-messages',
            room_id,
            false
          )
          AsyncTask.start(subscription.id) do
            driver.text(subscription.to_json)
          end
        end
      end
    end
  end
end
