require "active_support/json"

require 'rack/google-analytics'

require "tracking/custom_var"
require "tracking/event"
require "tracking/push"

require "google-analytics/instance_methods"

ActionController::Base.send(:include, GoogleAnalytics::InstanceMethods) if defined?(ActionController::Base)
