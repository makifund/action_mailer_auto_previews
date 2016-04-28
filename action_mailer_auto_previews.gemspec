# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'action_mailer_auto_previews/version'

Gem::Specification.new do |spec|
  spec.name          = "action_mailer_auto_previews"
  spec.version       = ActionMailerAutoPreviews::VERSION
  spec.authors       = ["Matthew B. Jones", "Andrew Yi"]
  spec.email         = ["matt@makifund.com", "andrew@makifund.com"]

  spec.summary       = %q{
    Enhances the ActionMailer Previews introduced in 4.1 by automatically creating ActionMailer Previews at runtime in development mode.
  }
  spec.description   = %q{
    Enhances the ActionMailer Previews introduced in 4.1 by automatically creating ActionMailer Previews at runtime in development mode.
    See automatic previews of your ActionMailer emails, with no extra effort or mock data. Install the action_mailer_auto_previews gem
    into your :development group, and it'll 'just work' with sensible defaults. Each ActionMailer email object that has .deliver or
    .deliver_later called will automatically launch your default browser right to a ActionMailer Preview page with the real data
    passed to that email. Flexible options allow you to alter this behavior as well.

    Warning: Since this is dynamically creating Ruby classes/methods, you will want to make sure your web-server is single threaded.
    For example, if you're using Puma, be sure to set the `workers` configuration parameter to 1.
  }
  spec.homepage      = "https://github.com/makifund/action_mailer_auto_previews"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "actionmailer", "~> 4.1"
  spec.add_dependency "launchy", "~> 2.4.3"
end
