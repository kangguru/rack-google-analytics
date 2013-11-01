require "active_support/json"
require "active_support/ordered_hash"

module GoogleAnalytics

  # A Struct that mirrors the structure of a custom var defined in Google Analytics
  # see https://developers.google.com/analytics/devguides/collection/gajs/eventTrackerGuide
  class Event < Struct.new(:category, :action, :label, :value)

    def write
      { hitType: 'event', eventCategory: self.category, eventAction: self.action, eventLabel: self.label, eventValue: self.value }.select{|k,v| v }.to_json
    end

  end
end