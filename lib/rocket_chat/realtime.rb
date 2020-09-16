# frozen_string_literal: true

require 'rocket_chat/realtime/version'
require 'rocket_chat/realtime/reactor'
require 'rocket_chat/realtime/connector'
require 'rocket_chat/realtime/adapter'
require 'rocket_chat/realtime/client'

module RocketChat
  # RocketChat Realtiem API
  module Realtime
    module_function

    # Connect to RocketChat
    #
    # @param options [Hash] connection options
    #
    # @return [RocketChat::Realtime::Client]
    #
    # @since 0.1.0
    def connect(options = {})
      client = Client.new(options)
      client.connect
      Reactor.run
      client
    end
  end
end
