require 'rack'
require 'erb'

module Rack

  class GoogleAnalytics

    EVENT_TRACKING_KEY = "google_analytics.event_tracking"
    DEFAULT = { async: true, enhanced_link_attribution: false, advertising: false }

    def initialize(app, options = {})
      @app, @options = app, DEFAULT.merge(options)
    end

    def call(env); dup._call(env); end

    def _call(env)
      @status, @headers, @body = @app.call(env)
      return [@status, @headers, @body] unless html?
      response = Rack::Response.new([], @status, @headers)
      @options[:tracker_vars] = env["google_analytics.custom_vars"] || []

      # Get any stored events from a redirection
      stored_events = env["rack.session"].delete(EVENT_TRACKING_KEY) if env["rack.session"]

      if response.ok?
        # Write out the events now
        @options[:tracker_vars] += (env[EVENT_TRACKING_KEY]) unless env[EVENT_TRACKING_KEY].nil?
        @options[:tracker_vars] += stored_events unless stored_events.nil?
      elsif response.redirection? && env["rack.session"]
        # Store the events until next time
        events_to_be_stored = (env[EVENT_TRACKING_KEY] || []) + (stored_events || [])
        env["rack.session"][EVENT_TRACKING_KEY] = events_to_be_stored unless events_to_be_stored.empty?
      end

      @options[:tracker] = expand_tracker(env, @options[:tracker])

      @body.each { |fragment| response.write inject(fragment) }
      @body.close if @body.respond_to?(:close)

      response.finish
    end

    private

    def html?; @headers['Content-Type'] =~ /html/; end

    def inject(response)
      @tracker_options = { cookieDomain: @options[:domain] }.select{|k,v| v }.to_json
      @template ||= ::ERB.new ::File.read ::File.expand_path("../templates/async.erb",__FILE__)

      response.gsub(%r{</head>}, @template.result(binding) + "</head>")
    end

    def expand_tracker(env, tracker)
      tracker.respond_to?(:call) ? tracker.call(env) : tracker
    end

  end

end
