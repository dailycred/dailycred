class Dailycred
  class Middleware
    attr_accessor :client_id

    def initialize(app, client_id, opts={})
      @opts = opts
      @opts[:url] ||= "https://www.dailycred.com"
      @opts[:modal] ||= false
      @opts[:triggers] ||= []
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
          home: "#{@opts[:url]}"
        };
        id = dc_opts.clientId;
        home = window.dc_opts.home || "https://www.dailycred.com";
        dlh = document.location.href;
        page = encodeURIComponent(dlh);
        title = document.title ? document.title : "";
        referrer = document.referrer ? encodeURIComponent(document.referrer) : "";
        dc = document.createElement("img");
        url = "" + home + "/dc.gif?url=" + page + "&title=" + title + "&client_id=" + window.dc_opts.clientId + "&referrer=" + referrer;
        dc.src = url;
        document.body.appendChild(dc);
      }).call(this);
      </script>
      <script src="#{@opts[:url]}/public/js/dailycred.coffee"></script>
      <script>
      DC.init({
          "showModal" : #{@opts[:modal]},
          "triggers"  : #{@opts[:triggers].to_s}
        });
      </script>
      <!-- end dailycred -->
      EOT
    end

  end
end
