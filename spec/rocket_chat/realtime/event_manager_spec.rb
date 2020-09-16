# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::EventManager do
  let(:options) { { server: 'wss://example.com' } }
  let(:client) { RocketChat::Realtime::Client.new(options) }
  let(:manager) { client.event }

  describe '#dispatch' do
    subject(:dispatch) { manager.dispatch(event) }

    let(:data) { {} }
    let(:event) { WebSocket::Driver::MessageEvent.new(data.to_json) }

    it { is_expected.to be_nil }

    context 'when ping message received' do
      let(:data) { { msg: 'ping' } }

      it { is_expected.to be_truthy }
    end

    context 'when result message received' do
      let(:data) { { msg: 'result' } }

      it { is_expected.to be_truthy }
    end
  end
end
