# frozen_string_literal: true

module DispatcherMacro
  def setup_dispatcher
    let(:options) { { server: 'wss://example.com' } }
    let(:client) { RocketChat::Realtime::Client.new(options) }
    let(:dispatcher) { RocketChat::Realtime::Dispatcher.new(client.driver) }
  end
end

RSpec.configure do |config|
  config.extend DispatcherMacro
end
