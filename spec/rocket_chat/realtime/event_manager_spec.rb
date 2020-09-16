# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::EventManager do
  let(:options) { { server: 'wss://example.com' } }
  let(:client) { RocketChat::Realtime::Client.new(options) }
  let(:manager) { client.event }

  describe '#dispatch' do
    subject { manager.dispatch(event) }

    let(:event) { WebSocket::Driver::MessageEvent.new('{}') }

    it { is_expected.to be_truthy }
  end
end
