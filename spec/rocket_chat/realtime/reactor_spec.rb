# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::Reactor do
  describe '.selector' do
    subject { described_class.selector }

    it { is_expected.to be_a(NIO::Selector) }
  end
end
