module Dailycred
  class User
    include ActiveModel::Validations
    include ActiveModel::Serialization

    validates_presence_of :email, :pass

    attr_accessor :client, :email, :pass, :authorized

    def initialize client, user = {}
      self.client = client
      self.authorized = false
      user.each do |k,v|
        self[k] = v if self.respond_to(k)
      end
    end

    def login
      if !self.valid?
        #it didn't work already, return false
        return false
      end

      response = JSON.parse client.login(self.to_hash)
      err_parser response

      return false if !self.valid?
      true
    end

    def to_hash
      {
        :email => self.email,
        :pass => self.pass
      }
    end

    private

    #response is a hash, which is
    #a json-parsed http response body
    def err_parser response
      if !response["worked"]
        self.authorized = false
        response["errors"].each do |err|
          attrib = err["attribute"]
          message = err["message"]
          if attrib == "form"
            self.errors.add_to_base message
          else
            if attrib == "user"
              self.errors.add :email, message
            elsif self.respond_to attrib
              self.errors.add attrib, message
            end
          end
        end
      end
    end

  end

end