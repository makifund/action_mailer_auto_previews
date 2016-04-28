require "action_mailer_auto_previews/version"
require "launchy"

# This gem uses sensible defaults, but can be altered as follows:
# @example
#  ActionMailerAutoPreviews.setup do |config|
#    config.enabled = true
#    config.history_limit = 10
#    config.intercept_mode = :preview_only
#    config.launch_browser = true
#    config.logger = Rails.logger
#    config.preview_host_url = "http://localhost:3000"
#  end
module ActionMailerAutoPreviews
  # This is a cache that holds onto the Mail objects for viewing via the ActionMailer::Preview web pages. This
  # cache will grow up the max capacity defined in the :history_limit attribute.
  MAIL_CACHE = {}

  mattr_accessor :enabled
  # Whether or not this gem and its functionality should be enabled
  @@enabled = Rails.env.development?

  mattr_accessor :history_limit
  # The maximum number of emails to keep around in MAIL_CACHE
  @@history_limit = 25

  mattr_accessor :intercept_mode
  # Whether to generate the Preview only (:preview_only), or, to generate the Preview and also do the default Mailer behavior
  @@intercept_mode = :preview_only

  mattr_accessor :launch_browser
  # Automatically launch the Preview in the default browser, otherwise, logs the new Preview URL to the logger
  @@launch_browser = true

  mattr_accessor :logger
  # Logger to be used. When nil (default), will use Rails.logger if Rails is present, otherwise, defaults to Logger.new(STDOUT)
  @@logger = nil

  mattr_accessor :preview_host_url
  # Base URL that is used for the Preview URLs. This should be set to the hostname and port of your development server.
  @@preview_host_url = "http://localhost:3000"

  # Call with a block to override one or more of the default configuration options.
  # @example
  #  ActionMailerAutoPreviews.setup do |config|
  #    config.launch_browser = false
  #    config.history_limit = 10
  #  end
  def self.setup
    yield self
  end

  private
  # Logic to return the appropriate logger to be used by this gem
  def self.logger
    @@logger ||= Object.const_defined?('Rails') ? Rails.logger : Logger.new(STDOUT)
  end

  # This method is the magic sauce of what we're trying to achieve. It is called via the patch on ActionMailer::MessageDelivery
  def self.auto_preview(message_delivery)
    # Generate a unique preview key
    preview_key = "preview_#{Time.now.to_i}#{rand(1000)}"

    # Store the message object that contains the data for the preview
    ActionMailerAutoPreviews::MAIL_CACHE[preview_key] = message_delivery

    # Dynamically add a ActionMailer::Preview method, named after `preview_key`
    eval %Q(
      class ActionMailerAutoPreviews::AutomaticPreviewMailer < ActionMailer::Preview
        define_method("#{preview_key}") do
          ActionMailerAutoPreviews::MAIL_CACHE["#{preview_key}"]
        end
      end
    )

    # Launch the default browser to the newly-available ActionMailer::Preview
    preview_url = "#{ActionMailerAutoPreviews.preview_host_url}/rails/mailers/action_mailer_auto_previews/automatic_preview_mailer/#{preview_key}"
    ActionMailerAutoPreviews.launch_browser ? Launchy.open(preview_url) : ActionMailerAutoPreviews.logger.info("New ActionMailer::Preview available at #{preview_url}")

    # Clean up the cache if the number of generated previews now exceeds `history_limit`
    if ActionMailerAutoPreviews::MAIL_CACHE.count > ActionMailerAutoPreviews.history_limit
      preview_key_to_purge = ActionMailerAutoPreviews::MAIL_CACHE.keys.first # Get the oldest preview_key
      ActionMailerAutoPreviews::MAIL_CACHE.delete preview_key_to_purge # Delete the reference to the mail object
      eval %Q(
        class ActionMailerAutoPreviews::AutomaticPreviewMailer < ActionMailer::Preview
          remove_method("#{preview_key_to_purge}")
        end
      ) # Removes the ActionMailer::Preview method, so the Preview is no longer available and the old URL will stop functioning
      ActionMailerAutoPreviews.logger.info("ActionMailer::Preview #{preview_key_to_purge} has been purged, history buffer is full")
    end
  end

  # Check to see if we should be enabled or not, and if so, patch into ActionMailer
  if ActionMailerAutoPreviews.enabled
    class ActionMailer::MessageDelivery
      def deliver(options={})
        ActionMailerAutoPreviews.auto_preview(self)
        super(options) if ActionMailerAutoPreviews.intercept_mode == :preview_and_deliver
      end

      def deliver_later(options={})
        ActionMailerAutoPreviews.auto_preview(self)
        super(options) if ActionMailerAutoPreviews.intercept_mode == :preview_and_deliver
      end
    end
  end
end
