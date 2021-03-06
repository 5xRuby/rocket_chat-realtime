# frozen_string_literal: true

RSpec.describe RocketChat::Realtime do
  it 'has a version number' do
    expect(RocketChat::Realtime::VERSION).not_to be nil
  end

  describe '.logger' do
    subject { described_class.logger }

    it { is_expected.to be_a(Logger) }

    context 'when customize logger' do
      let(:logger) { Logger.new(STDERR) }

      before { described_class.logger = logger }

      it { is_expected.to eq(logger) }
    end
  end

  describe '.connect' do
    subject { described_class.connect(options) }

    let(:addr) { '127.0.0.1' }
    let(:server) { TCPServer.new(addr, 0) }
    let(:port) { server.local_address.ip_port }

    let(:options) do
      {
        server: "ws://#{addr}:#{port}"
      }
    end

    before { server }

    after do
      server.close
      RocketChat::Realtime::Reactor.stop
    end

    it { is_expected.to be_a(RocketChat::Realtime::Client) }
  end
end
