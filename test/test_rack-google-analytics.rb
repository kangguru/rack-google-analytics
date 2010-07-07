require File.expand_path('../helper',__FILE__)

class TestRackGoogleAnalytics < Test::Unit::TestCase
  
  context "Asyncrous" do
    context "default" do
      setup { mock_app :async => true, :tracker => 'somebody' }
      should "show asyncronous tracker" do
        get "/"
        assert_match %r{\_gaq\.push}, last_response.body
        assert_match %r{\'\_setAccount\', \"somebody\"}, last_response.body
        assert_equal "495", last_response.headers['Content-Length']
      end

      should "not add tracker to none html content-type" do
        get "/test.xml"
        assert_no_match %r{\_gaq\.push}, last_response.body
        assert_match %r{Xml here}, last_response.body
      end

      should "not add without </head>" do
        get "/bob"
        assert_no_match %r{\_gaq\.push}, last_response.body
        assert_match %r{bob here}, last_response.body
      end
    end
  end
  
  context "Regular" do
    setup { mock_app :async => false, :tracker => 'whatthe' }
  end
end
