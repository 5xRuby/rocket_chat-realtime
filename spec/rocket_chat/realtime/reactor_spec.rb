# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::Reactor do
  after { described_class.reset }

  describe '.selector' do
    subject { described_class.selector }

    it { is_expected.to be_a(NIO::Selector) }
  end

  describe '.clients' do
    subject { described_class.clients }

    it { is_expected.to be_a(Set) }
  end

  describe '.register' do
    subject { described_class.register(client) }

    let(:client) { RocketChat::Realtime::Client.new(server: 'wss://example.com') }

    it { is_expected.not_to be_nil }

    context 'when client is registered' do
      before { client.connect }

      it { is_expected.to be_nil }
    end
  end

  describe '.deregister' do
    subject(:deregister) { described_class.deregister(client) }

    let(:client) { RocketChat::Realtime::Client.new(server: 'wss://example.com') }

    it { is_expected.to be_nil }

    context 'when client is registered' do
      before { described_class.register(client) }

      it { is_expected.not_to be_nil }
    end
  end

  describe '.registered?' do
    subject { described_class.registered?(client) }

    let(:client) { RocketChat::Realtime::Client.new(server: 'wss://example.com') }

    it { is_expected.to be_falsy }

    context 'when client is registed' do
      before { client.connect }

      it { is_expected.to be_truthy }
    end
  end

  describe '.stop' do
    subject { described_class.stop }

    it { is_expected.to be_truthy }
  end

  describe '.stopped?' do
    subject { described_class.stopped? }

    it { is_expected.to be_falsy }

    context 'when reactor stopped' do
      before { described_class.stop }

      it { is_expected.to be_truthy }
    end
  end
end
