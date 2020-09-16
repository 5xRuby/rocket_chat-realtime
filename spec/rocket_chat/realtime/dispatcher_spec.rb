# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::Dispatcher do
  let(:options) { { server: 'wss://example.com' } }
  let(:client) { RocketChat::Realtime::Client.new(options) }
  let(:dispatcher) { described_class.new(client.driver, client.event) }

  describe '#dispatch' do
    subject(:dispatch) { dispatcher.dispatch(event) }

    let(:data) { {} }
    let(:event) { WebSocket::Driver::MessageEvent.new(data.to_json) }

    it { is_expected.to be_falsy }
  end
end
