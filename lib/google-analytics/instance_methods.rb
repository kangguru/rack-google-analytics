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

    # Sets a custom variable on a page load
    #
    # e.g. writes
    # _gaq.push(['_setCustomVar',
    #      2,                   // This custom var is set to slot #2.  Required parameter.
    #      'Shopping Attempts', // The name of the custom variable.  Required parameter.
    #      'Yes',               // The value of the custom variable.  Required parameter.
    #                           //  (you might set this value by default to No)
    #      2                    // Sets the scope to session-level.  Optional parameter.
    #   ]);
    def set_ga_custom_var(slot, name, value, scope = nil)
      var = GoogleAnalytics::CustomVar.new(slot, name, value, scope)

      ga_custom_vars.push(var)
    end

    # Tracks an event or goal on a page load
    #
    # e.g. writes
    # _gaq.push(['_trackEvent', 'Videos', 'Play', 'Gone With the Wind']);
    #
    def track_ga_event(category, action, label = nil, value = nil, noninteraction = nil)
      var = GoogleAnalytics::Event.new(category, action, label, value, noninteraction)
      ga_events.push(var)
    end

    def ga_push(*attributes)
      var = GoogleAnalytics::Push.new(attributes)
      ga_events.push(var)
    end

  end
end
