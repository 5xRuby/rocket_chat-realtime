# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::Messages::Result do
  let(:id) { SecureRandom.uuid }
  let(:result) { {} }
  let(:method) { described_class.new(id, result) }

  describe '#body' do
    subject { method.body }

    it { is_expected.to have_key(:result) }
  end

  describe '#[]' do
    subject { method[attr] }

    let(:attr) { 'token' }

    it { is_expected.to be_nil }

    context 'when result contains token' do
      let(:result) { { 'token' => 'dummy' } }

      it { is_expected.not_to be_nil }
      it { is_expected.to eq('dummy') }
    end
  end
end
