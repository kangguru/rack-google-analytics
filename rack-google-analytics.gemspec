# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|

  s.name        = "rack-google-analytics"
  s.version     = File.read('VERSION').to_s
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Lee Hambley"]
  s.email       = ["lee.hambley@gmail.com"]
  s.homepage    = "https://github.com/leehambley/rack-google-analytics"
  s.summary     = "Rack middleware to inject the Google Analytics tracking code into outgoing responses."
  s.description = "Simple Rack middleware for implementing google analytics tracking in your Ruby-Rack based project. Supports synchronous and asynchronous insertion and configurable load options."

  s.files        = Dir.glob("lib/**/*") + %w(README.md LICENSE)
  s.require_path = 'lib'

end
