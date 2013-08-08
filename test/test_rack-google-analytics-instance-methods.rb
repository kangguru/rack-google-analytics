$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'rack'
require 'rack/test'
require 'active_support/core_ext/hash/slice'
require "action_controller"
require File.expand_path('../../lib/rack-google-analytics', __FILE__)

class TestRackGoogleAnalyticsInstanceMethods < Test::Unit::TestCase

  include Rack::Test::Methods

  class MockController < ActionController::Base
    def index
      set_ga_custom_var(1, "Items Removed", "Yes", GoogleAnalytics::CustomVar::SESSION_LEVEL)
      track_ga_event("Users", "Login", "Standard")
      ga_push("_addItem", "ID", "SKU")
      render :inline => "<html><head><title>Title</title></head><body>Hello World</body></html>"
    end

    def action_method?(name)
      true
    end
  end

  def controller
    MockController.action(:index)
  end

  # Build an app to call our MockController with GoogleAnalytics middleware
  def mock_app(options)
    builder = Rack::Builder.new
    builder.use Rack::GoogleAnalytics, options
    builder.run controller
    @app = builder.to_app
  end

  def app;
    Rack::Lint.new(@app);
  end

  context "Instance Methods" do
    setup { mock_app :async => true, :tracker => 'whatthe' }

    context "pass variables to rack" do

      should "have event tracking" do
        get "/"
        assert last_response.ok?

        assert_match %r{\_gaq\.push}, last_response.body
        assert_match %r{_trackEvent.*_trackPageview}m, last_response.body
        assert_match %r{Users}, last_response.body
        assert_match %r{Login}, last_response.body
        assert_match %r{Standard}, last_response.body
      end

      should "have custom vars" do
        get :index
        assert last_response.ok?

        assert_match %r{\_gaq\.push}, last_response.body
        assert_match %r{_setCustomVar.*_trackPageview}m, last_response.body
        assert_match %r{Items Removed}, last_response.body
        assert_match %r{Yes}, last_response.body
      end

      should "have generic push" do
        get "/"
        assert last_response.ok?

        assert_match %r{\_gaq\.push}, last_response.body
        assert_match %r{_addItem.*_trackPageview}m, last_response.body
        assert_match %r{ID}, last_response.body
        assert_match %r{SKU}, last_response.body
      end
    end
  end

end
