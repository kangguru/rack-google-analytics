require 'rack'
require 'erb'

module Rack

  class GoogleAnalytics

    DEFAULT = { :async => true }

    def initialize(app, options = {})
      raise ArgumentError, "Tracker must be set!" unless options[:tracker] and !options[:tracker].empty?
      @app, @options = app, DEFAULT.merge(options)
    end

    def call(env); dup._call(env); end

    def _call(env)
      @status, @headers, @body = @app.call(env)
      return [@status, @headers, @body] unless html?
      response = Rack::Response.new([], @status, @headers)
      @body.each { |fragment| response.write inject(fragment) }
      @body.close if @body.respond_to?(:close)

      response.finish
    end

    private

    def html?; @headers['Content-Type'] =~ /html/; end

    def inject(response)
      file = @options[:async] ? 'async' : 'sync'
      @template ||= ::ERB.new ::File.read ::File.expand_path("../templates/#{file}.erb",__FILE__)
      if @options[:async]
        response.gsub(%r{</head>}, @template.result(binding) + "</head>")
      else
        response.gsub(%r{</body>}, @template.result(binding) + "</body>")
      end
    end

  end

end
