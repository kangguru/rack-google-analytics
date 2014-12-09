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

    context "with e-commerce" do
      setup { mock_app tracker: 'happy', ecommerce: true }
      should "require ecommerce" do
        get "/"
        assert_match %r{ga\('require', 'ecommerce', 'ecommerce\.js'\)}, last_response.body
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

    context "with multiple trackers" do
      setup { mock_app trackers: [['name1','horchata'], ['name2','slurpee']]}
      should "show multiple trackers" do
        get "/"
        assert_match %r{ga\('create', 'horchata', {}\)}, last_response.body
        assert_match %r{ga\('create', 'slurpee', {}\)}, last_response.body
      end
      should "should trigger pageview for each tracker" do
        get "/"
        assert_match %r{ga\('send', 'pageview'\);}, last_response.body
        assert_match %r{ga\('name2.send', 'pageview'\);}, last_response.body
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
