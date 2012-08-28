class Dailycred
  class Middleware
    attr_accessor :client_id

    def initialize(app, client_id)
      @app = app 
      @client_id = client_id
    end

    def call(env)
      @env = env
      @status, @headers, @response = @app.call(env)

      if @headers["Content-Type"] =~ /text\/html|application\/xhtml\+xml/
        body = ""
        @response.each { |part| body << part }
        index = body.rindex("</body>")
        if index
          body.insert(index, render_dailycred_scripts)
          @headers["Content-Length"] = body.length.to_s
          @response = [body]
        end
      end

      [@status, @headers, @response]
    end

    private

    def render_dailycred_scripts
      <<-EOT
      <!-- dailycred -->
      <script type="text/javascript">
      (function() {
        var dc, dlh, home, id, page, referrer, title, url;
        window.dc_opts = {
          clientId: "#{@client_id}",
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
