# MsteamsNotifier

Microsoft Teams Webhook Message

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'msteams_notifier'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install msteams_notifier

## Usage

If using Rails, add credentials:

    // config/credentials.yml
    ms_teams:
      webhook_url: http://url
      enabled: 1

Send a quick message:

    MsteamsNotifier.quick_message("Hello World")

Add other fields:

    n = MsteamsNotifier.new
    n.add_title "New Notification"
    n.add_text  "A new shirt is on it's way!"
    n.add_facts [{title: 'Color', value: 'Red'}, {title: 'Size', value: 'XL'}]
    n.add_text "Get ready to go"
    n.add_action "View", "http://url.com"
    n.send

Set the webhook_url manually:

    MsteamsNotifier.new(
      webhook_url: "http://url.com",
      enabled: true  
    )

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/msteams_notifier. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/msteams_notifier/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MsteamsNotifier project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/msteams_notifier/blob/master/CODE_OF_CONDUCT.md).
