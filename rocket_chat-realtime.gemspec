# frozen_string_literal: true

require_relative 'lib/rocket_chat/realtime/version'

Gem::Specification.new do |spec|
  spec.name          = 'rocket_chat-realtime'
  spec.version       = RocketChat::Realtime::VERSION
  spec.authors       = ['5xRuby']
  spec.email         = ['hello@5xruby.com']

  spec.summary       = 'Rocket.Chat realtime api client'
  spec.description   = 'Rocket.Chat realtime api client'
  spec.homepage      = 'https://github.com/5xRuby/rocket_chat-realtime'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'concurrent-ruby', '~> 1.1'
  spec.add_runtime_dependency 'nio4r', '~> 2.5'
  spec.add_runtime_dependency 'websocket-driver', '~> 0.7'
end
