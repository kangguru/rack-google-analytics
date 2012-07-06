module GoogleAnalytics

  # A Struct that mirrors the structure of a custom var defined in Google Analytics
  # see https://developers.google.com/analytics/devguides/collection/gajs/gaTrackingCustomVariables
  class CustomVar < Struct.new(:index, :name, :value, :opt_scope)
    VISITOR_LEVEL = 1
    SESSION_LEVEL = 2
    PAGE_LEVEL = 3

    def write
      ['_setCustomVar', self.index, self.name, self.value,self.opt_scope].to_json
    end
  end
end