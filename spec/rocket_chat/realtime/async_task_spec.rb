# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::AsyncTask do
  describe '.start' do
    subject(:start) { described_class.start(id) }

    let(:id) { 'example' }

    it { is_expected.not_to be_nil }
    it { is_expected.to be_a(Concurrent::Promises::ResolvableFuture) }

    context 'when task is started' do
      let!(:current_task) { start }

      it { is_expected.to eq(current_task) }
    end
  end

  describe '.resolve' do
    subject(:resolve) { described_class.resolve(id, result) }

    let(:id) { 'example' }
    let(:result) { 'result' }

    let!(:task) { described_class.start(id) }

    it { is_expected.to be_a(Concurrent::Promises::ResolvableFuture) }
    it { expect { resolve }.to change(task, :fulfilled?).from(false).to(true) }
  end
end
