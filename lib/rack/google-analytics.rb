require 'rack'
require 'erb'

module Rack

  class GoogleAnalytics

    EVENT_TRACKING_KEY = "google_analytics.event_tracking"

    DEFAULT = { :async => true, :advertising => false, :inpage_pageid => false }

    def initialize(app, options = {})
      raise ArgumentError, "Tracker must be set!" unless valid_tracker?(options[:tracker])
      @app, @options = app, DEFAULT.merge(options)
    end

    def call(env); dup._call(env); end

    def _call(env)
      @status, @headers, @body = @app.call(env)
      return [@status, @headers, @body] unless html?
      return [@status, @headers, @body] if skip?(env)

      response = Rack::Response.new([], @status, @headers)
      @options[:tracker_vars] = env["google_analytics.custom_vars"] || []

      if response.ok?
        # Write out the events now
        @options[:tracker_vars] += (env[EVENT_TRACKING_KEY]) unless env[EVENT_TRACKING_KEY].nil?

        # Get any stored events from a redirection
        session = env["rack.session"]
        stored_events = session.delete(EVENT_TRACKING_KEY) if session
        @options[:tracker_vars] += stored_events unless stored_events.nil?
      elsif response.redirection? && env["rack.session"]
        # Store the events until next time
        env["rack.session"][EVENT_TRACKING_KEY] = env[EVENT_TRACKING_KEY]
      end
      @tracker = tracker(env, @options[:tracker])

      @body.each { |fragment| response.write inject(fragment) }
      @body.close if @body.respond_to?(:close)

      response.finish
    end

    private

    # tracker should be non-nil, non-empty string or a lambda
    def valid_tracker?(tracker)
      return false unless tracker
      return (tracker.respond_to?(:call) && tracker.lambda?) || !tracker.empty?
    end

    def html?; @headers['Content-Type'] =~ /html/; end

    def inject(response)
      file = @options[:async] ? 'async' : 'sync'

      @template ||= ::ERB.new ::File.read ::File.expand_path("../templates/#{file}.erb",__FILE__)
      if @options[:async]
        response.gsub(%r{</head>}, @template.result(binding) + "</head>")
      else
        response.gsub(%r{</body>}, @template.result(binding) + "</body>")
      end
    end

    # obtain tracking code dynamically if it's a lambda, use the string directly otherwise
    def tracker(env, tracker)
      return tracker unless tracker.respond_to?(:call)
      return tracker.call(env)
    end

    def skip?(env)
      return false if @options[:if].nil?
      return !@options[:if] unless @options[:if].respond_to?(:call)
      return !@options[:if].call(env)
    end

  end

end
