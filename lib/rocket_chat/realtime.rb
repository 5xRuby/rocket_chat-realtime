# frozen_string_literal: true

require 'logger'

require 'rocket_chat/realtime/version'
require 'rocket_chat/realtime/message'
require 'rocket_chat/realtime/method_message'
require 'rocket_chat/realtime/subscribe_message'
require 'rocket_chat/realtime/result_message'
require 'rocket_chat/realtime/reactor'
require 'rocket_chat/realtime/connector'
require 'rocket_chat/realtime/adapter'
require 'rocket_chat/realtime/dispatcher'
require 'rocket_chat/realtime/async_task'
require 'rocket_chat/realtime/client'

module RocketChat
  # RocketChat Realtiem API
  #
  # The Realtime API is depend on Metero.js DDP
  # https://github.com/meteor/meteor/blob/devel/packages/ddp/DDP.md
  #
  # @since 0.1.0
  module Realtime
    module_function

    # Logger
    #
    # @return [Logger]
    #
    # @since 0.1.0
    def logger
      @logger ||=
        Logger.new(STDERR, progname: name, level: Logger::ERROR)
    end

    # Set logger
    #
    # @param logger [Logger]
    #
    # @since 0.1.0
    def logger=(logger)
      @logger = logger
    end

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
