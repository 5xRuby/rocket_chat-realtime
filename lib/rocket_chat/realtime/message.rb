# frozen_string_literal: true

require 'securerandom'

module RocketChat
  module Realtime
    # Abstract message model to send a method
    #
    # @since 0.1.0
    class Message
      # @since 0.1.0
      attr_reader :id, :type

      # @param type [String] message type
      # @param id [String] unique id to identity command
      #
      # @since 0.1.0
      def initialize(type = 'method', id = nil)
        @id = id || SecureRandom.uuid
        @type = type
      end

      # Body
      #
      # @return [Hash] the message body
      def body
        {}
      end

      # Convert to JSON
      #
      # @return [String] message json
      def to_json(options = nil)
        body
          .merge(id: @id, msg: @type)
          .to_json(options)
      end
    end
  end
end
