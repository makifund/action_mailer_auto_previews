# ActionMailerAutoPreviews

![Demo Video](https://media.giphy.com/media/26AHFOLhi11OmM0Yo/giphy.gif)

Enhances the ActionMailer Previews introduced in 4.1 by automatically creating ActionMailer Previews at runtime in development mode.
See automatic previews of your ActionMailer emails, with no extra effort or mock data. Install the `action_mailer_auto_previews` gem
into your :development group, and it'll 'just work' with sensible defaults. Each ActionMailer email object that has `.deliver` or
`.deliver_later` called will automatically launch your default browser right to a ActionMailer Preview page with the real data
passed to that email. Flexible options allow you to alter this behavior as well.

Warning: Since this is dynamically creating Ruby classes/methods, you will want to make sure your web-server is single threaded.
For example, if you're using Puma, be sure to set the `workers` configuration parameter to 1.

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

###### Enabling / Disabling
By default, the gem will be enabled in development mode. To have finer control, you can set `config.enabled` to false.
```ruby
config.enabled = false # Set to false to disable
```

###### History limit
You can control how many automatic email previews are kept around for your viewing. By default, this is set to `10`. You can see past automatic emails by visiting `http://localhost:3000/rails/mailers/action_mailer_auto_previews`.
```ruby
config.history_limit = 50 # Keep 50 previews
```

###### Intecept Mode
The default behavior is to automatically launch your default browser to the newly generate email preview, and then suppress the default implementation of `deliver` or `deliver_later`. If you would like it to launch your browser _and_ continue with the original `deliver` and `deliver_later`, simply set this configuration value to `:preview_and_deliver`
```ruby
config.intercept_mode = :preview_and_deliver # Show preview and still "deliver"
```

###### Automatic Browser Launching
You can configure whether or not your default browser launches automatically. The default configuration is to automatically launch, however, if you choose to disable this, the URL to the newly-available email preview will be logged to the configured logger.
```ruby
config.launch_browser = false # Do not launch the default browser
```
![Terminal Output](http://blog.makifund.com/action_mailer_auto_previews/images/example_terminal_output.png)

###### Logger
When setting `config.launch_browser = false`, the URLs to the automatic email previews will be logged to the configured logger. By default, the logger is set to `Rails.logger` when Rails is detected, otherwise it will be `Logger.new(STDOUT)`
```ruby
config.logger = Logger.new(STDOUT)
```

###### Preview Host URL
You can change the base URL that the gem uses to serve up the automatic email previews. This is helpful if you're not running your webserver on port 3000, or, you wish to use a different hostname, or any other reason.
```ruby
config.preview_host_url = "http://localhost:5000"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/makifund/action_mailer_auto_previews.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

