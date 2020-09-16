# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::Message do
  let(:type) { 'method' }
  let(:id) { nil }
  let(:message) { described_class.new(type, id) }

  describe '#to_json' do
    subject(:json) { message.to_json }

    it { is_expected.to be_a(String) }
    it { expect(JSON.parse(json)).to have_key('id') }
    it { expect(JSON.parse(json)).to have_key('msg') }
  end
end
