require File.expand_path('../helper',__FILE__)

class TestRackGoogleAnalyticsEvents < Test::Unit::TestCase
  
  context "Asyncronous With Events" do
    context "default" do
      setup do
          events = [GoogleAnalytics::Event.new("Users", "Login", "Standard")]
          mock_app :async => true, :tracker => 'somebody', :events => events
      end
      should "show events" do
        get "/"

        assert_match %r{\_gaq\.push}, last_response.body
        assert_match %r{_trackEvent}, last_response.body
        assert_match %r{Users}, last_response.body
        assert_match %r{Login}, last_response.body
        assert_match %r{Standard}, last_response.body
      end

    end
  end

  context "Asyncronous With Custom Vars" do
    context "default" do
      setup do
          custom_vars = [GoogleAnalytics::CustomVar.new(1, "Items Removed", "Yes", GoogleAnalytics::CustomVar::SESSION_LEVEL)]
          mock_app :async => true, :tracker => 'somebody', :custom_vars => custom_vars
      end
      should "show events" do
        get "/"

        assert_match %r{\_gaq\.push}, last_response.body
        assert_match %r{_setCustomVar}, last_response.body
        assert_match %r{Items Removed}, last_response.body
        assert_match %r{Yes}, last_response.body
      end

    end
  end

  context "Test Instance Methods" do
    context "default" do
      setup do
          custom_vars = [GoogleAnalytics::CustomVar.new(1, "Items Removed", "Yes", GoogleAnalytics::CustomVar::SESSION_LEVEL)]
          mock_app :async => true, :tracker => 'somebody', :custom_vars => custom_vars
      end
      should "show events" do
#        controller.set_ga_custom_var(GoogleAnalytics::CustomVar.new(1, "Items Removed", "Yes", GoogleAnalytics::CustomVar::SESSION_LEVEL))

        get "/"

        assert_match %r{\_gaq\.push}, last_response.body
        assert_match %r{_setCustomVar}, last_response.body
        assert_match %r{Items Removed}, last_response.body
        assert_match %r{Yes}, last_response.body
      end

    end
  end


end
