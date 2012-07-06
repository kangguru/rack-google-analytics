require "rack/google-analytics"
require "tracking/custom_var"

require "google-analytics/instance_methods"

ActionController::Base.send(:include, GoogleAnalytics::InstanceMethods)
