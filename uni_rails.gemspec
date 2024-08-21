# frozen_string_literal: true

require_relative "lib/uni_rails/version"

Gem::Specification.new do |spec|
  spec.name = "uni_rails"
  spec.version = UniRails::VERSION
  spec.authors = ["Alexandre Barret"]
  spec.email = ["barret.alx@gmail.com"]

  spec.summary = "A Ruby library to create single-file Rails application"
  spec.homepage = "https://github.com/AlexB52/uni_rails"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/AlexB52/uni_rails"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "rails", "~> 7.1.0"
  spec.add_dependency "rackup", "~> 2.1"
  spec.add_dependency "turbo-rails", "~> 2.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
