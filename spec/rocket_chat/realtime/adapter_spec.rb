# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::Adapter do
  let(:url) { 'wss://example.com/websocket' }
  let(:adapter) { described_class.new(url) }

  describe '#pump_buffer' do
    subject { adapter.pump_buffer(io) }

    let(:io) { StringIO.new }

    it { is_expected.to be_zero }

    context 'when buffer contains data' do
      before { adapter.write('Hello World') }

      it { is_expected.to be(11) }
    end
  end
end
