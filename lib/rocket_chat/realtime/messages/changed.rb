# frozen_string_literal: true

require 'rocket_chat/realtime/message'

module RocketChat
  module Realtime
    module Messages
      # The changed message
      #
      # The DDP subscription changed message
      #
      # @since 0.1.0
      class Changed < Message
        # @since 0.1.0
        attr_reader :fields, :cleared, :collection

        # @param args [Array] the parameters for method
        def initialize(id, message)
          super('changed', id)

          @fields = message.fetch('fields', nil)
          @cleared = message.fetch('cleared', nil)
          @collection = message.fetch('collection', nil)
        end

        # @see RocketChat::Realtime::Message#body
        #
        # @since 0.1.0
        def body
          {
            fields: fields,
            cleared: cleared,
            collection: collection
          }
        end

        # :nodoc:
        def [](key)
          fields.fetch(key.to_s, nil)
        end
      end
    end
  end
end
