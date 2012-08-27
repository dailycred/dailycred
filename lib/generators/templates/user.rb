class User < ActiveRecord::Base
  serialize :tags
  serialize :referred

  def self.create_with_omniauth(model)
    info = model[:info]
    create! do |user|
      user.provider = model[:provider]
      user.uid = model[:uid]
      user.email =info[:email]
      user.username = info[:username]
      user.created = info[:created]
      user.verified = info[:verified]
      user.admin = info[:admin]
      user.referred_by = info[:referred_by]
    end
  end

end
