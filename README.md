# RocketChat::Realtime

The ruby implement for [RocketChat Realtime API](https://docs.rocket.chat/api/realtime-api).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rocket_chat-realtime'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rocket_chat-realtime

## Usage

### Create a client

```ruby
client = RocketChat::Realtime::Client.new(server: 'wss://chat.example.com')
```

### Connect to server

```ruby
client.connect
```

or use a shortcut via `.connect`

```ruby
client = RocketChat::Realtime.connect(server: 'wss://chat.example.com')
```

### Login to server

```ruby
client.login(username, password)
```

The Realtime API is async and depend on the Metro.js DDP, we can use `Concurrent::Promises` to capture the return message.

```ruby
client
  .login(username, password)
  .then { |res| puts "Token is #{res['token']}" }
```

### Subscribe room messages

```ruby
client
  .subscribe_room_messages('ROOM_ID')
  .then { puts 'Ready!' }
```

### Process room messages

```ruby
client.on('stream-room-messages') do |message|
  puts "Received message: #{message['args'][0]['msg']}"
end
```

### Send message

```ruby
client
  .send_message('ROOM_ID', 'MESSAGE')
  .then { |res| puts 'Success' }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/5xRuby/rocket_chat-realtime. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/5xRuby/rocket_chat-realtime/blob/master/CODE_OF_CONDUCT.md).


## Code of Conduct

Everyone interacting in the RocketChat::Realtime project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/5xRuby/rocket_chat-realtime/blob/master/CODE_OF_CONDUCT.md).
