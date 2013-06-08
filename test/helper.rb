require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'rack/test'
require 'active_support/core_ext/hash/slice'
require File.expand_path('../../lib/rack/google-analytics', __FILE__)
require File.expand_path('../../lib/tracking/custom_var', __FILE__)
require File.expand_path('../../lib/tracking/event', __FILE__)

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

class Test::Unit::TestCase
  include Rack::Test::Methods

  def app;
    Rack::Lint.new(@app);
  end

  def main_app(options)
    lambda { |env|

      env["google_analytics.event_tracking"] = options[:events] if options[:events]
      env["google_analytics.custom_vars"] = options[:custom_vars] if options[:custom_vars]

      request = Rack::Request.new(env)
      case request.path
        when '/' then
          [200, {'Content-Type' => 'application/html'}, ['<head>Hello world</head>']]
        when '/test.xml' then
          [200, {'Content-Type' => 'application/xml'}, ['Xml here']]
        when '/bob' then
          [200, {'Content-Type' => 'application/html'}, ['<body>bob here</body>']]
        else
          [404, 'Nothing here']
      end
    }
  end

  def mock_app(options)
    app_options = options.slice(:events, :custom_vars)

    builder = Rack::Builder.new
    builder.use Rack::GoogleAnalytics, options
    builder.run main_app(app_options)
    @app = builder.to_app
  end
end
