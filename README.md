# ActionMailerAutoPreviews

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/action_mailer_auto_previews`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile :development group:

```ruby
group :development do
  gem 'action_mailer_auto_previews'
end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install action_mailer_auto_previews

## Usage

That's it! Simply include the gem in your Gemfile's :development group, and by default, you will be able to automatically see previews of your ActionMailer emails. Whenever `deliver` or `deliver_later`
is called on one of your ActionMailers, the gem will automatically generate the ActionMailer::Preview required and open the preview in your default browser. However, there are several configuration options
that can be used to alter this behavior.

## Configuration Options
```ruby
ActionMailerAutoPreviews.setup do |config|
  config.enabled = true
  config.history_limit = 10
  config.intercept_mode = :preview_only # [:preview_only, :preview_and_deliver]
  config.launch_browser = true
  config.logger = Rails.logger
  config.preview_host_url = "http://localhost:3000"
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/makifund/action_mailer_auto_previews.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

