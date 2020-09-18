# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::Handlers::Result do
  let(:client) { RocketChat::Realtime::Client.new(server: 'wss://example.com') }
  let(:dispatcher) { RocketChat::Realtime::Dispatcher.new(client.driver) }
  let(:message) { { 'id' => 'example', 'result' => {} } }
  let(:handler) { described_class.new(dispatcher, message) }

  describe '#result' do
    subject(:result) { handler.result }

    it { expect(result.id).to eq('example') }
    it { expect(result.result).to eq({}) }
  end

  describe '#process' do
    subject(:process) { handler.process }

    let!(:task) { RocketChat::Realtime::AsyncTask.start('example') }

    it { expect { process }.to change(task, :fulfilled?).from(false).to(true) }
  end
end
