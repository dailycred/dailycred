class Dailycred
  class MiddleWare
    def initialize(app, client_id)
      @app = app 
      @token = client_id
    end

    def call(env)
      @env = env
      @status, @headers, @response = @app.call(env)
      #if good status, html response, and non-ajax request
      if @status == 302 && (@headers["Content-Type"].include?("text/html") if @headers.has_key?("Content-Type")) && !(@env.has_key?("HTTP_X_REQUESTED_WITH") && @env["HTTP_X_REQUESTED_WITH"] == "XMLHttpRequest")
        @response.each do |part|
          insert_at = part.index '</body'
          part.insert insert_at, render_dailycred_scripts
        end
      end
    end

    private

    def render_dailycred_scripts
      <<-EOT
      <!-- dailycred -->
      <script type="text/javascript">
      (function() {
        var dc, dlh, home, id, page, referrer, title, url;
        window.dc_opts = {
          clientId: "#{token}",s
          home: "https://www.dailycred.com"
        };
        id = dc_opts.clientId;
        home = "https://www.dailycred.com";
        dlh = document.location.href;
        page = dlh.indexOf('#') > -1 ? dlh.substring(0, dlh.indexOf("#")) : dlh;
        title = document.title ? document.title : "";
        referrer = document.referrer ? document.referrer : "";
        dc = document.createElement("img");
        url = "" + home + "/dc.gif?page=" + page + "&title=" + title + "&client_id=" + window.dc_opts.clientId + "&referrer=" + referrer;
        dc.src = url;
        document.body.appendChild(dc);
      }).call(this);
      </script>
      <!-- end dailycred -->
      EOT
    end

  end
end
