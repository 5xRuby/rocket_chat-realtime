# frozen_string_literal: true

module RocketChat
  module Realtime
    # Socket Adapter for WebSocket::Driver
    #
    # @since 0.1.0
    class Adapter
      # @since 0.1.0
      attr_reader :url

      # @param url [String] the server to connect
      #
      # @since 0.1.0
      def initialize(url)
        @url = url
        @mutex = Mutex.new
        @buffer = ''
      end

      # Enqueue data to send to server
      #
      # @param data [String]
      #
      # @since 0.1.0
      def write(data)
        @mutex.synchronize { @buffer = @buffer.dup.concat(data) }
      end

      # Pump Buffer
      #
      # @param io [IO] the data write to
      #
      # @return [Number] total bytes written
      #
      # @since 0.1.0
      def pump_buffer(io)
        @mutex.synchronize do
          written = 0
          begin
            written = io.write_nonblock @buffer unless @buffer.empty?
            @buffer = @buffer.byteslice(written..-1) if written.positive?
          rescue IO::WaitWritable, IO::WaitReadable
            return written
          end
          written
        end
      end
    end
  end
end
