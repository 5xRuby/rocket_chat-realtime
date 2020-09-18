# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::Handlers::Base do
  setup_dispatcher
  let(:message) { {} }
  let(:handler) { described_class.new(dispatcher, message) }

  describe '.call' do
    subject(:call) { described_class.call(dispatcher, message) }

    it { expect { call }.to raise_error(NotImplementedError) }
  end

  describe '#process' do
    subject(:process) { handler.process }

    it { expect { process }.to raise_error(NotImplementedError) }
  end
end
