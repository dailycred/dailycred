module ActsAsDailycred
  def acts_as_dailycred
    serialize :facebook, Hash
    serialize :twitter, Hash
    serialize :google, Hash
    serialize :github, Hash
    serialize :tags, Array
    serialize :referred, Array

    attr_accessible :email, :username, :created, :verified, :admin, :referred_by, :referred,
      :facebook, :tags, :provider, :uid, :token, :twitter, :google, :github
    extend ActsAsDailycred::SingletonMethods
  end
  module SingletonMethods
    def find_or_create_with_omniauth(model)
      @user = User.find_by_provider_and_uid(model[:provider], model[:uid]) || User.new
      @user.update_attributes model[:info]
      @user
    end
  end
  module InstanceMethods
  end
end
require 'active_record'
ActiveRecord::Base.extend ActsAsDailycred