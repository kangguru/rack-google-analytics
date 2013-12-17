# Rack google Analytics

[![Build Status](https://travis-ci.org/kangguru/rack-google-analytics.png?branch=analytics-js)](https://travis-ci.org/kangguru/rack-google-analytics)

Simple Rack middleware to help injecting the Google Analytics tracking code in your website.

This middleware injects the Google Analytics tracking code into the correct place of any request only when the response's `Content-Type` header contains `html` (therefore `text/html` and similar).

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

#### Rails 3.X and Rails 4.X

```ruby
## application.rb:
config.middleware.use Rack::GoogleAnalytics, :tracker => 'UA-xxxxxx-x'
```

### Options

* `:anonymize_ip` -  sets the tracker to remove the last octet from all IP addresses, see https://developers.google.com/analytics/devguides/collection/gajs/methods/gaJSApi_gat?hl=de#_gat._anonymizeIp for details.
* `:domain`     -  sets the domain name for the GATC cookies. Defaults to `auto`. (must also set :multiple)
* `:site_speed_sample_rate` - Defines a new sample set size for Site Speed data collection, see https://developers.google.com/analytics/devguides/collection/gajs/methods/gaJSApiBasicConfiguration?hl=de#_gat.GA_Tracker_._setSiteSpeedSampleRate
* `:enhanced_link_attribution` - Enable enhanced link attribution, see https://support.google.com/analytics/answer/2558867?hl=en
* `:adjusted_bounce_rate_timeouts` - An array of times in seconds that the tracker will use to set timeouts for adjusted bounce rate tracking. See http://analytics.blogspot.ca/2012/07/tracking-adjusted-bounce-rate-in-google.html for details.

If you are not sure what's best, go with the defaults, and read here if you should opt-out.

## Event Tracking

In your application controller, you may track an event. For example:

```ruby
ga_track_event("Users", "Login", "Standard")
```

See https://developers.google.com/analytics/devguides/collection/analyticsjs/events

## Custom Push

In your application controller, you may push arbritrary data. For example:

```ruby
ga_push("_addItem", "ID", "SKU")
```

## Dynamic Tracking Code

You may instead define your tracking code as a lambda taking the Rack environment, so that you may set the tracking code
dynamically based upon information in the Rack environment. For example:

```ruby
config.middleware.use Rack::GoogleAnalytics, :tracker => lambda { |env|
        return env[:site_ga].tracker if env[:site_ga]
}
```

## Special use case:  Event tracking only

If you already set up your Google Analytics `analytics.js` tracker object with pageview tracking in your templates/frontend (inside the `<head>`), the only thing you might want to use the `rack-google-analytics` middleware for is to track server-side events which you can't properly track in the forntend.  In that case simply use the middleware without specifying the `:tracker` option, then it will only render the event tracking code (`ga('send', hitType: 'event', ..)`) and nothing else.

    config.middleware.use Rack::GoogleAnalytics


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
