require "active_support/json"

module GoogleAnalytics

  # A Struct that mirrors the structure of a custom var defined in Google Analytics
  # see https://developers.google.com/analytics/devguides/collection/gajs/eventTrackerGuide
  class Event < Struct.new(:category, :action, :label, :value, :noninteraction)

    def write
      ['_trackEvent', self.category, self.action, self.label,self.value, self.noninteraction].to_json
    end
  end
end