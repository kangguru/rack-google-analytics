# rack-google-analytics

Simple Rack middleware to help injecting the google analytics tracking code into the footer of your websites.

This middleware injects the code directly before the `</body>` tag of documents matching the `Content-Type` of `/html/` (therefore `text/html`). You should also be aware that as this rewrites the body length, the `Content-Length` header is also removed (sure, I could rewrite it, but i'm not aware of any benefits.)

As of 0.6 the class is called Rack::GoogleAnalytics, in 0.5 and earlier this was incorrectly documented, and this name has now been decided upon.

As of `0.2.0` there are no tests as I have not had chance to do this right.

Version 0.2.0 implements the default code to be the asynchronous google code (see: http://bit.ly/async-analytics ).

## Usage

  require 'rack-google-analytics'
  use Rack::GoogleAnalytics, :tracker => 'UA-xxxxxx-x'
  
Note: since 0.2.0 this will use the asynchronous google tracker code, for the traditional behaviour please use:

  require 'rack-google-analytics'
  use Rack::GoogleAnalytics, :tracker => 'UA-xxxxxx-x', :async => false

If you are not sure what's best, go with the defaults, and read here if you should opt-out 

## Thread Safety

This middleware *should* be thread safe. Although my experience in such areas is limited, having taken the advice of those with more experience; I defer the call to a shallow copy of the environment, if this is of consequence to you please review the implementation.

## Change Log

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

Copyright (c) 2009 Lee Hambley. See LICENSE for details.
With thanks to Ralph von der Heyden http://github.com/ralph/ and Simon `cimm` Schoeters http://github.com/cimm/ - And the biggest hand to Arthur `achiu` Chiu for the huge work that went into the massive 0.9 re-factor.
