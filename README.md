# Rack google Analytics

Simple Rack middleware to help injecting the Google Analytics tracking code in your website.

This middleware injects either the synchronous or asynchronous Google Analytics tracking code into the correct place of any request only when the response's `Content-Type` header contains `html` (therefore `text/html` and similar).

## Usage

#### Gemfile

```ruby
gem 'rack-google-analytics'
```

#### Sinatra

```ruby
## app.rb
use Rack::GoogleAnalytics, :tracker => 'UA-xxxxxx-x'
```

#### Padrino

```ruby
## app/app.rb
use Rack::GoogleAnalytics, :tracker => 'UA-xxxxxx-x'
```

#### Rails 2.X

```ruby
## environment.rb:
config.gem 'rack-google-analytics', :lib => 'rack/google-analytics'
config.middleware.use Rack::GoogleAnalytics, :tracker => 'UA-xxxxxx-x'
```

### Options

* `:async`      -  sets to use asynchronous tracker
* `:multiple`   -  sets track for multiple subdomains. (must also set :domain)
* `:top_level`  -  sets tracker for multiple top-level domains. (must also set :domain)

Note: since 0.2.0 this will use the asynchronous Google Analytics tracking code, for the traditional behaviour please use:

```ruby
use Rack::GoogleAnalytics, :tracker => 'UA-xxxxxx-x', :async => false
```

If you are not sure what's best, go with the defaults, and read here if you should opt-out.

## Thread Safety

This middleware *should* be thread safe. Although my experience in such areas is limited, having taken the advice of those with more experience; I defer the call to a shallow copy of the environment, if this is of consequence to you please review the implementation.

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2009-2012 Lee Hambley. See LICENSE for details.
With thanks to [Ralph von der Heyden](https://github.com/ralph) and [Simon Schoeters](https://github.com/cimm) - And the biggest hand to [Arthur Chiu](https://github.com/achiu) for the huge work that went into the massive 0.9 re-factor.
