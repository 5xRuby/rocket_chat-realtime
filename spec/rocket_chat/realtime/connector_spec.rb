# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::Connector do
  let(:url) { 'ws://example.com/socket' }
  let(:connector) { described_class.new(url) }

  describe '#hostname' do
    subject { connector.hostname }

    it { is_expected.to eq('example.com') }
  end

  describe '#port' do
    subject { connector.port }

    it { is_expected.to eq(80) }

    context 'when url is wss' do
      let(:url) { 'wss://example.com/socket' }

      it { is_expected.to eq(443) }
    end

    context 'when port is customize' do
      let(:url) { 'wss://example.com:9090/socket' }

      it { is_expected.to eq(9090) }
    end
  end

  describe '#ssl?' do
    subject { connector.ssl? }

    it { is_expected.to be_falsy }

    context 'when url is wss' do
      let(:url) { 'wss://example.com/socket' }

      it { is_expected.to be_truthy }
    end
  end

  describe '#connect' do
    subject { connector.connect }

    it { is_expected.to be_a(TCPSocket) }

    context 'when url is wss' do
      let(:url) { 'wss://example.com/socket' }

      it { is_expected.to be_a(OpenSSL::SSL::SSLSocket) }
    end
  end
end
