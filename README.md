# WebinarRu
This gem wrap webinar.ru API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'webinar_ru'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install webinar_ru

## Usage

```ruby
client = WebinarRu.client(token: "XXXXXXX")
event_id = client.events.create(
  name: "Test", access: 1, starts_at: starts_at, duration: duration, description: "Test event!", ends_at: ends_at
).value.id
event = client.organization.events(id: event_id).show.value
session_id = client.events(id: event_id).sessions.create(name: "Webinar", access: 1).value.id
events = client.organization.events.schedule(from: starts_at - day).value
client.users(id: user_id).events.schedule(from: starts_at - day).value
session_id = events.first.sessions.first.id
client.event_sessions(id: session_id).show.value

client.event_sessions(id: session_id).register(email: "skiline.alex@gmail.com")
client.event_sessions(id: session_id).invite(users: [email: "79650368741@ya.ru"], send_email: false)
client.event_sessions(id: session_id).participants
# NOTE! https://help.webinar.ru/ru/articles/3181373-записи-пояснения-к-разделу
client.event_sessions(id: session_id).conversions.create(quality: 720)
client.records.conversions(conversion_id: conversion_id).status
client.records.index(from: starts_at, to: ends_at)

client.event_sessions(id: session_id).destroy # Danger! it deletes event too
client.organization.events(id: event_id).destroy # => 404
```

## Debug
```ruby
WebinarRu.logger = Logger.new("tmp/test.log")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/webinar_ru. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/webinar_ru/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the WebinarRu project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/webinar_ru/blob/master/CODE_OF_CONDUCT.md).
