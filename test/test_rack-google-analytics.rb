require 'helper'

class TestRackGoogleAnalytics < Test::Unit::TestCase

  context "Asyncronous" do
    context "default" do
      setup { mock_app tracker: 'somebody' }
      should "show asyncronous tracker" do
        get "/"
        assert_match %r{ga\('create', 'somebody', {}\)}, last_response.body
        assert_match %r{ga\('send', 'pageview'\)}, last_response.body

        assert_match %r{</script></head>}, last_response.body
      end

      should "not add tracker to none html content-type" do
        get "/test.xml"
        assert_no_match %r{ga\('create', 'somebody', {}\)}, last_response.body

        assert_match %r{Xml here}, last_response.body
      end

      should "not add without </head>" do
        get "/bob"
        assert_no_match %r{ga\('create', 'somebody', {}\)}, last_response.body
        assert_match %r{bob here}, last_response.body
      end

      should "redirects" do
        get "/redirect"
        assert_equal 302, last_response.status
      end
    end

    context "memorized events" do
      setup do
        events = [GoogleAnalytics::Event.new("NewEvent", "Happens", "Standard")]
        rack_session = { "google_analytics.event_tracking" => [GoogleAnalytics::Event.new("OldEvent", "Happened", "Standard")] }
        mock_app :async => true, :tracker => 'somebody', :events => events, :rack_session => rack_session
      end
      should "add both events on success" do
        get "/"
        assert_match %r{ga\('send', {\"hitType\":\"event\",\"eventCategory\":\"NewEvent\",\"eventAction\":\"Happens\",\"eventLabel\":\"Standard\"}\)}, last_response.body
        assert_match %r{ga\('send', {\"hitType\":\"event\",\"eventCategory\":\"OldEvent\",\"eventAction\":\"Happened\",\"eventLabel\":\"Standard\"}\)}, last_response.body
      end

      should "store both events on redirect" do
        get "/redirect"
        assert_equal 302, last_response.status
        assert_equal [GoogleAnalytics::Event.new("NewEvent", "Happens", "Standard"), GoogleAnalytics::Event.new("OldEvent", "Happened", "Standard")], last_request.env['rack.session']['google_analytics.event_tracking']
      end
    end

    context "with custom domain" do
      setup { mock_app tracker: 'somebody', domain: "railslabs.com" }

      should "show asyncronous tracker with cookieDomain" do
        get "/"
        assert_match %r{ga\('create', 'somebody', {\"cookieDomain\":\"railslabs.com\"}\)}, last_response.body
        assert_match %r{ga\('send', 'pageview'\)}, last_response.body

        assert_match %r{</script></head>}, last_response.body
      end

    end

    context "with enhanced_link_attribution" do
      setup { mock_app tracker: 'happy', enhanced_link_attribution: true }
      should "embedded the linkid plugin script" do
        get "/"
        assert_match %r{linkid.js}, last_response.body
      end
    end

    context "with advertising" do
      setup { mock_app tracker: 'happy', advertising: true }
      should "require displayfeatures" do
        get "/"
        assert_match %r{ga\('require', 'displayfeatures'\)}, last_response.body
      end
    end

    context "with anonymizeIp" do
      setup { mock_app :async => true, :tracker => 'happy', :anonymize_ip => true }
      should "set anonymizeIp to true" do
        get "/"
        assert_match %r{ga\('set', 'anonymizeIp', true\)}, last_response.body
      end
    end

    context "with dynamic tracker" do
      setup do
        mock_app tracker: lambda { |env| return env["misc"] }, misc: "foobar"
      end

      should 'call tracker lambdas to obtain tracking codes' do
        get '/'
        assert_match %r{ga\('create', 'foobar', {}\)}, last_response.body
      end
    end

    context 'adjusted bounce rate' do
      setup do
        mock_app tracker: 'afake', adjusted_bounce_rate_timeouts: [15, 30]
      end
      should "add timeouts to push read events" do
         get "/"
         assert_match %r{ga\('send', 'event', '15_seconds', 'read'\)}, last_response.body
         assert_match %r{ga\('send', 'event', '30_seconds', 'read'\)}, last_response.body
      end
    end

    # context "with custom _setSiteSpeedSampleRate" do
    #   setup { mock_app :async => true, :tracker => 'happy', :site_speed_sample_rate => 5 }
    #   should "add top_level domain script" do
    #     get "/"
    #     assert_match %r{'_setSiteSpeedSampleRate', 5}, last_response.body
    #   end
    # end

  end

end
