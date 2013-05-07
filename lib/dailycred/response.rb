module Dailycred
  class Response
    require 'json'
    attr_accessor :json, :body, :headers, :status

    def initialize response
      @body = response.body
      @json = JSON.parse(@body)
      @headers = response.headers
      @status = response.status
    end

    def errors?
      json["worked"] != true
    end

    def success?
      @status == 200 && json["worked"] == true
    end

    def errors
      begin
        json["errors"][0]
      rescue
        nil
      end
    end

    def user
      json["user"]
    end
  end
end