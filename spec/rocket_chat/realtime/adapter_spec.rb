# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::Adapter do
  let(:selector) { NIO::Selector.new }
  let(:monitor) { selector.register(socket, :rw) }

  let(:addr) { '127.0.0.1' }

  let(:server) { TCPServer.new(addr, 0) }
  let(:port) { server.local_address.ip_port }
  let(:socket) { TCPSocket.new(addr, port) }

  let(:url) { 'wss://example.com/websocket' }
  let(:adapter) { described_class.new(url, monitor) }

  describe '#pump_buffer' do
    subject(:pump_buffer) { adapter.pump_buffer }

    it { is_expected.to be_zero }

    context 'when buffer contains data' do
      before { adapter.write('Hello World') }

      it { is_expected.to be_zero }
    end
  end
end
