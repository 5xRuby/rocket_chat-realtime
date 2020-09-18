# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::Messages::Method do
  let(:name) { 'login' }
  let(:parameters) { [] }
  let(:method) { described_class.new(name, *parameters) }

  describe '#body' do
    subject { method.body }

    it { is_expected.to have_key(:method) }
    it { is_expected.to have_key(:params) }
  end
end
