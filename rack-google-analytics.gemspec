# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'rack/google-analytics/version'

Gem::Specification.new do |s|
  s.name        = "rack-google-analytics"
  s.version     = Rack::GoogleAnalytics::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Lee Hambley"]
  s.email       = ["lee.hambley@gmail.com"]
  s.homepage    = "https://github.com/leehambley/rack-google-analytics"
  s.summary     = "Rack middleware to inject the Google Analytics tracking code into outgoing responses."
  s.description = "Simple Rack middleware for implementing google analytics tracking in your Ruby-Rack based project. Supports synchronous and asynchronous insertion and configurable load options."

  s.files        = Dir.glob("lib/**/*") + %w(README.md LICENSE)
  s.require_path = 'lib'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'test-unit', '~> 2.5.1'
  s.add_development_dependency 'shoulda',   '~> 2.11.3'
  s.add_development_dependency 'rack',      '~> 1.2.0'
  s.add_development_dependency 'rack-test', '~> 0.5.4'
end
