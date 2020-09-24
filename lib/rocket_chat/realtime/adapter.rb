# frozen_string_literal: true

module RocketChat
  module Realtime
    # Socket Adapter for WebSocket::Driver
    #
    # @since 0.1.0
    class Adapter
      # @since 0.1.0
      attr_reader :url, :monitor

      # @param url [String] the server to connect
      #
      # @since 0.1.0
      def initialize(url, monitor)
        @url = url
        @monitor = monitor
        @mutex = Mutex.new
        @buffer = ''
      end

      def pending?
        @buffer.empty? == false
      end

      def dispose
        @monitor = nil
      end

      # Enqueue data to send to server
      #
      # @param data [String]
      #
      # @since 0.1.0
      def write(data)
        @mutex.synchronize { @buffer = @buffer.dup.concat(data) }
        pump_buffer
        Reactor.selector.wakeup unless monitor.interests == :r
      end

      # Pump Buffer
      #
      # @param io [IO] the data write to
      #
      # @return [Number] total bytes written
      #
      # @since 0.1.0
      def pump_buffer
        @mutex.synchronize do
          written = 0
          written = monitor.io.write_nonblock @buffer unless @buffer.empty?
          @buffer = @buffer.byteslice(written..-1) if written.positive?
          written
        end
      rescue IO::WaitWritable, IO::WaitReadable
        written
      ensure
        monitor.interests = pending? ? :rw : :r
      end
    end
  end
end
