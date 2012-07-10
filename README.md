# Rack google Analytics

Simple Rack middleware to help injecting the google analytics tracking code into the footer of your websites.

This middleware injects either the synchronous or asynchronous google analytics tracker code into the correct place of any request with `Content-Type` containing `html` (therefore `text/html` and similar).

Formerly this gem had an environments setting, that has been removed pending refactoring.

## Usage

#### Gemfile:
    gem 'rack-google-analytics', :require => 'rack/google-analytics'

#### Sinatra
    ## app.rb
    use Rack::GoogleAnalytics, :tracker => 'UA-xxxxxx-x'

#### Padrino

    ## app/app.rb
    use Rack::GoogleAnalytics, :tracker => 'UA-xxxxxx-x'

#### Rails

    ## environment.rb:
    config.gem 'rack-google-analytics', :lib => 'rack/google-analytics'
    config.middleware.use Rack::GoogleAnalytics, :tracker => 'UA-xxxxxx-x'

### Options

* :async      -  sets to use asyncronous tracker  
* :multiple   -  sets track for multiple sub domains. (must also set :domain)
* :top_level  -  sets tracker for multiple top-level domains. (must also set :domain)

Note: since 0.2.0 this will use the asynchronous google tracker code, for the traditional behaviour please use:

    use Rack::GoogleAnalytics, :tracker => 'UA-xxxxxx-x', :async => false

If you are not sure what's best, go with the defaults, and read here if you should opt-out

## Custom Variable Tracking

** Added in this fork only **

In your application controller, you may track a custom variable. For example:

    set_ga_custom_var(1, "LoggedIn", value, GoogleAnalytics::CustomVar::SESSION_LEVEL)

See https://developers.google.com/analytics/devguides/collection/gajs/gaTrackingCustomVariables for details.

## Event Tracking

** Added in this fork only **

In your application controller, you may track an event. For example:

    track_ga_event("Users", "Login", "Standard")

See https://developers.google.com/analytics/devguides/collection/gajs/eventTrackerGuide

## Thread Safety

This middleware *should* be thread safe. Although my experience in such areas is limited, having taken the advice of those with more experience; I defer the call to a shallow copy of the environment, if this is of consequence to you please review the implementation.

## Change Log

* 0.10.0 Include the Google pagespeed code, and `README` typos fixed.
* 0.9.2  Fixed a bug with lots of missing files from the Gem... how silly!
* 0.9.1  Updated readme to reflect 0.9.0 merge from achiu
* 0.9.0  Include name changed from 'rack-google-analytics' to 'rack/google-analytics' more inline with the norm
* 0.6.0  Class now named Rack::GoogleAnalytics, in 0.5 and earlier this was incorrectly documented as Rack::GoogleTracker
* 0.2.0  Asynchronous code is now the default.

* 22-07-2010 Major re-write from Arthur Chiu, now correctly writes the Content-Length leader, and comes with tests (High five to @achiu) - this patch also backs-out the changes from @cimm - but they were un-tested (I intend to bring these back as soon as possible; this will probably constitute a 1.0 release when it happens)
* 19-01-2010 Second Release, patch from github.com/ralph - makes the default snippet the async version from google. Use regular synchronous code with: `:async => false`
* 27-12-2009 First Release, extracted from the Capistrano-Website project and packaged with Jeweler.

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2009-2011 Lee Hambley. See LICENSE for details.
With thanks to Ralph von der Heyden http://github.com/ralph/ and Simon `cimm` Schoeters http://github.com/cimm/ - And the biggest hand to Arthur `achiu` Chiu for the huge work that went into the massive 0.9 re-factor.
