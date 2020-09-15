# frozen_string_literal: true

require 'uri'
require 'openssl'
require 'forwardable'

module RocketChat
  module Realtime
    # Socket manager
    #
    # @since 0.1.0
    class Connector
      extend Forwardable

      delegate %w[hostname] => :uri

      # @since 0.1.0
      attr_reader :uri

      # @param url [String] the websocket server to connect
      #
      # @since 0.1.0
      def initialize(url)
        @uri = URI(url)
      end

      # Connect to server
      #
      # @return [Socket] the socket
      def connect
        return @socket if @socket
        return raw_socket unless ssl?

        ssl_socket
      end

      alias socket connect

      # Check the SSL enabled
      #
      # @return [Boolean] is enabled
      #
      # @since 0.1.0
      def ssl?
        @uri.scheme == 'wss'
      end

      # The port to connect
      #
      # @return [Number] the port
      #
      # @since 0.1.0
      def port
        @uri.port || (ssl? ? 443 : 80)
      end

      protected

      # @return [Socket] the raw tcp socket
      def raw_socket
        @socket = TCPSocket.new hostname, port
      end

      # @return [OpenSSL::SSL::SSLSocket] the ssl socket
      def ssl_socket
        store = OpenSSL::X509::Store.new
        store.set_default_paths

        ctx = OpenSSL::SSL::SSLContext.new
        ctx.verify_mode = OpenSSL::SSL::VERIFY_PEER
        ctx.cert_store = store

        @socket = OpenSSL::SSL::SSLSocket.new(raw_socket, ctx)
        @socket.hostname = @uri.hostname
        @socket.connect
      end
    end
  end
end
