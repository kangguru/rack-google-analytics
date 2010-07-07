module Rack

  class GoogleAnalytics
    DEFAULT = { :async => true, :env => 'production', :append => "</head>" }
    
    def initialize(app, options = {})
      raise ArgumentError, "Tracker must be set!" unless options[:tracker] and !options[:tracker].empty?
      @app, @options = app, DEFAULT.merge(options)
    end

    def call(env); dup._call(env); end

    def _call(env)
      @status, @headers, @response = @app.call(env)
      return [@status, @headers, @response] unless html?
      response = Rack::Response.new([], @status, @headers)
      @response.each { |fragment| response.write inject(fragment) }
      response.finish
    end

    def inject(response)
      file = @options[:async] ? 'async' : 'tracker'
      template = ::ERB.new ::File.read ::File.expand_path("../templates/#{file}.erb",__FILE__)
      response.gsub(%r{#{@options[:append]}}, @options[:append] + template.result(binding))
    end
    
    private
    def rails?; defined?(Rails) && Rails.env.casecmp(@env) == 0; end
    def html?; @headers['Content-Type'] =~ /html/; end
  end

end
