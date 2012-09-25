module Dailycred
  class Middleware
    attr_accessor :client_id

    def initialize(app, client_id, opts={})
      @opts = opts
      @opts[:url] ||= "https://www.dailycred.com"
      @opts[:modal] ||= false
      @opts[:sdk] ||= false
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
      str =<<-EOT
      <!-- dailycred -->
      <script type="text/javascript">
      (function() {
        var dc, url;
        window.dc_opts = {
          clientId: "#{@client_id}",
          home: "#{@opts[:url]}"
        };
        dc = document.createElement("script");
        url = dc_opts.home + "/public/js/cred.coffee";
        dc.src = url;
        document.body.appendChild(dc);
      }).call(this);
      </script>
      EOT
      str2 =<<-EOT
      <script src="#{@opts[:url]}/public/js/dailycred.coffee"></script>
      <script>
      DC.init({
          "showModal" : #{@opts[:modal]}
          #{',"modal":{"triggers":'+@opts[:triggers].to_s+'}' if @opts[:modal]}
        });
      </script>
      EOT
      str += str2 if @opts[:sdk]
      str += "\n<!-- end dailycred -->"
      str
    end

  end
end
