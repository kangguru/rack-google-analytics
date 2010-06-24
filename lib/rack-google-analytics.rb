module Rack

  class GoogleTracker

    TRACKER_CODE = <<-EOTC
    <script type="text/javascript">
    var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
    document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
    </script>
    <script type="text/javascript">
    try{
    var pageTracker = _gat._getTracker("UA-xxxxxx-x");
    pageTracker._trackPageview();
    } catch(err) {}</script>
    EOTC

    ASYNC_TRACKER_CODE = <<-EOTC
    <script type="text/javascript">

      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', 'UA-xxxxxx-x']);
      _gaq.push(['_trackPageview']);

      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(ga);
      })();

    </script>
    EOTC

    def initialize(app, options = {})
      raise ArgumentError, "Tracker must be set!" unless options[:tracker] and !options[:tracker].empty?
      @app     = app
      @tracker = options[:tracker]
      @async   = options[:async] || true
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)

      @status, @headers, @response = @app.call(env)
      return [@status, @headers, @response] unless @headers['Content-Type'] =~ /html/

      @headers.delete('Content-Length')
      response = Rack::Response.new([], @status, @headers)
      @response.each do |fragment|
        response.write(inject_tracker(fragment))
      end
      response.finish
    end

    def inject_tracker(response)
      if @async
        tracker_code = ASYNC_TRACKER_CODE.sub(/UA-xxxxxx-x/, @tracker)
      else
        tracker_code = TRACKER_CODE.sub(/UA-xxxxxx-x/, @tracker)
      end
      response.sub!(/<body>/, "<body>\n#{tracker_code}\n") rescue response
    end

  end

end