# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::EventEmitter do
  let(:klass) { Class.new }
  let(:emitter) { klass.new }

  before do
    klass.include described_class
  end

  describe '#on' do
    subject { emitter.on('dummy') {} }

    it { is_expected.not_to be_empty }
    it { is_expected.to be_a(Array) }
  end

  describe '#off' do
    subject { emitter.off('dummy', &callback) }

    let(:callback) { proc {} }

    before { emitter.on('dummy', &callback) }

    it { is_expected.to be_nil }
  end

  describe '#emit' do
    subject(:emit) { emitter.emit('dummy', 1) }

    let(:variable) { Struct.new(:value).new(0) }
    let(:callback) { proc { |v| variable.value = v } }

    before { emitter.on('dummy', &callback) }

    it { expect { emit }.to change(variable, :value).from(0).to(1) }
  end
end
