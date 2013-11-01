# This module holds all instance methods to be
# included into ActionController::Base class
# for enabling google analytics var tracking in a Rails app.
#
require "erb"

module GoogleAnalytics
  module InstanceMethods

    private

    def ga_custom_vars
      self.env["google_analytics.custom_vars"] ||= []
    end

    def ga_events
      self.env["google_analytics.event_tracking"] ||= []
    end

    protected

    # Tracks an event or goal on a page load
    #
    # e.g. writes
    # ga.('send', 'event', 'Videos', 'Play', 'Gone With the Wind');
    #
    def ga_track_event(category, action, label = nil, value = nil)
      ga_events.push(GoogleAnalytics::Event.new(category, action, label, value))
    end

    def ga_push(*attributes)
      var = GoogleAnalytics::Push.new(attributes)
      ga_events.push(var)
    end

  end
end
