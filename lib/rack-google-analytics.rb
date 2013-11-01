require "active_support/json"
require "active_support/ordered_hash"

require 'rack/google-analytics'

require "tracking/event"
require "tracking/push"

require "google-analytics/instance_methods"

ActionController::Base.send(:include, GoogleAnalytics::InstanceMethods) if defined?(ActionController::Base)
