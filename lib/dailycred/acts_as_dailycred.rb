module ActsAsDailycred
  def acts_as_dailycred
    serialize :facebook, Hash
    serialize :twitter, Hash
    serialize :google, Hash
    serialize :github, Hash
    serialize :tags, Array
    serialize :referred, Array
    serialize :access_tokens, Hash

    extend ActsAsDailycred::SingletonMethods
    include ActsAsDailycred::InstanceMethods
    include Dailycred::Helpers
  end
  module SingletonMethods
    def find_or_create_with_omniauth(model)
      @user = User.find_by_provider_and_uid(model[:provider], model[:uid]) || User.new
      @user.update_from_dailycred model[:info]
      @user
    end
  end
  module InstanceMethods
    def tag tag
      dc = get_client
      response = dc.tag self.uid, tag
      json = JSON.parse(response.body)
      if json['worked']
        self.tags << tag
        save!
      end
    end

    def untag tag
      dc = get_client
      response = dc.untag self.uid, tag
      json = JSON.parse(response.body)
      if json['worked']
        self.tags.delete tag
        save!
      end
    end

    def display_name
      display = self.email || ""
      if self.facebook != {}
        return self.facebook["name"]
      elsif self.google != {}
        return self.google["name"]
      elsif self.twitter != {}
        return "@"+self.twitter["screen_name"]
      end
      display
    end

    def referral_link url
      "https://www.dailycred.com/r/#{self.uid}?redirect_uri=#{url}"
    end
    def reset_password
      get_client.reset_password self.email
    end

    def update_from_dailycred dc
      bad = ['updated_at', 'created_at']
      p dc
      dc.each do |k,v|
        self[k] = v if self.respond_to?(k) and !bad.include?(k.to_s)
      end
      save!
    end

    def fire_event key, val=""
      get_client.event self.uid, key, val
    end

    def get_client
      @dailycred ||= Dailycred::Client.new Rails.configuration.DAILYCRED_CLIENT_ID, Rails.configuration.DAILYCRED_SECRET_KEY
    end

    def connect_path provider
      "/auth/dailycred?identity_provider=#{provider.to_s}"
    end
  end
end
require 'active_record'
ActiveRecord::Base.extend ActsAsDailycred