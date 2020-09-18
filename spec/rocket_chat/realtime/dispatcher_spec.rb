# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::Dispatcher do
  setup_dispatcher

  describe '#dispatch' do
    subject(:dispatch) { dispatcher.dispatch(event) }

    let(:data) { {} }
    let(:event) { WebSocket::Driver::MessageEvent.new(data.to_json) }

    it { is_expected.to be_falsy }

    context 'when find dispatch handler' do
      let(:data) { { msg: :ping } }

      it { is_expected.to be_truthy }
    end
  end
end
