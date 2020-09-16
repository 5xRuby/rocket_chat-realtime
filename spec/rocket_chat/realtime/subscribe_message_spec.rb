# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::SubscribeMessage do
  let(:name) { 'stream-room-messages' }
  let(:parameters) { ['__my_messages__'] }
  let(:method) { described_class.new(name, *parameters) }

  describe '#body' do
    subject { method.body }

    it { is_expected.to have_key(:name) }
    it { is_expected.to have_key(:params) }
  end
end
