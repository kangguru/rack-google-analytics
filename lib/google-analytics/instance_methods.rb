# This module holds all instance methods to be
# included into ActionController::Base class
# for enabling google analytics var tracking in a Rails app.
#
require "erb"

module GoogleAnalytics
  module InstanceMethods

    def set_ga_custom_var(var)
      raise "Must be instance of CustomVar" unless var.instance_of?(CustomVar)

      # Store it in an instance var as well as the flash, in case of a redirect
      self.env["google_analytics.custom_vars"] ||= []
      self.env["google_analytics.custom_vars"].push(var)
    end
  end
end
