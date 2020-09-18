# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::Handlers::Ready do
  let(:client) { RocketChat::Realtime::Client.new(server: 'wss://example.com') }
  let(:dispatcher) { RocketChat::Realtime::Dispatcher.new(client.driver) }
  let(:message) { { 'subs' => %w[sub1 sub2] } }
  let(:handler) { described_class.new(dispatcher, message) }

  describe '#process' do
    subject(:process) { handler.process }

    let!(:sub1) { RocketChat::Realtime::AsyncTask.start('sub1') }
    let!(:sub2) { RocketChat::Realtime::AsyncTask.start('sub2') }

    it { expect { process }.to change(sub1, :fulfilled?).from(false).to(true) }
    it { expect { process }.to change(sub2, :fulfilled?).from(false).to(true) }
  end
end
