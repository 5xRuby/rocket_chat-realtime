# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RocketChat::Realtime::Methods::Auth do
  let(:klass) { Class.new }
  let(:driver) { instance_double(WebSocket::Driver::Client) }
  let(:client) { klass.new }

  before do
    klass.include described_class
    allow(client).to receive(:driver).and_return(driver)
    allow(driver).to receive(:text).and_return(true)
  end

  describe '#login' do
    subject { client.login('user', 'pass') }

    it { is_expected.to be_truthy }
  end
end
