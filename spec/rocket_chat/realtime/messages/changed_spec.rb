# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::Messages::Changed do
  let(:id) { SecureRandom.uuid }
  let(:message) { { 'fields' => {}, 'collection' => '', 'cleared' => [] } }
  let(:method) { described_class.new(id, message) }

  describe '#body' do
    subject { method.body }

    it { is_expected.to have_key(:fields) }
    it { is_expected.to have_key(:cleared) }
    it { is_expected.to have_key(:collection) }
  end

  describe '#[]' do
    subject { method[attr] }

    let(:attr) { 'token' }

    it { is_expected.to be_nil }

    context 'when result contains token' do
      let(:message) { { 'fields' => { 'token' => 'dummy' } } }

      it { is_expected.not_to be_nil }
      it { is_expected.to eq('dummy') }
    end
  end
end
