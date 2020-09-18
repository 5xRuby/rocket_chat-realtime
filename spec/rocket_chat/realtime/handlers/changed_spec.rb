# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::Handlers::Changed do
  setup_dispatcher
  let(:message) { { 'id' => 'example', 'collection' => 'stream-room-messages', 'fields' => {} } }
  let(:handler) { described_class.new(dispatcher, message) }

  describe '#changed' do
    subject(:changed) { handler.changed }

    it { expect(changed.id).to eq('example') }
    it { expect(changed.collection).to eq('stream-room-messages') }
    it { expect(changed.fields).to eq({}) }
  end

  describe '#process' do
    subject(:process) { handler.process }

    let(:changed) { Struct.new(:id).new(nil) }
    let(:callback) { proc { |message| changed.id = message.id } }

    before { dispatcher.client.on('stream-room-messages', &callback) }

    it { expect { process }.to change(changed, :id).from(nil).to('example') }
  end
end
