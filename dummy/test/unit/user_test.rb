require_relative '../test_helper.rb'
class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:basic)
  end
  test 'tagging a user' do
    @user.tag 'awesome'
    assert_tag 'awesome'
  end
  test 'untagging a user' do
    t = 'bad'
    @user.tag t
    assert_tag t
    @user.untag t
    assert_not_tag t
  end

  test 'resetting a password' do
    assert_true json_response(@user.reset_password)['worked']
  end

  test 'updating from dailycred' do
    dc = {
      email: 'hank@2.com',
      tags: ['hello','awesome'],
      referred: ['danny', 'betty'],
      username: 'hstove',
      created: 111222333,
      verified: false,
      admin: false,
      referred_by: 'marky',
      referred: ['chris', 'mike'],
      facebook: {
        id: 100203,
        email: 'hank@facebook.com'
      },
      provider: 'dailycred',
      token: 'ha243k',
      twitter: {
        screen_name: 'heynky'
      },
      google: {
        email: 'hstove@gg.com'
      },
      github: {
        repos: ['123','ruby on rails']
      },
      subscribed: false,
      display: 'hanky'
    }
    @user.update_from_dailycred dc
    dc.each do |k,v|
      assert_equal v, @user[k], "user should have value of |#{v}| for |#{k}| but was |#{@user[k].to_s}|"
    end
  end

  test 'firing an event' do
    assert_true json_response(@user.fire_event 'got tested')['worked']
  end

  def json_response response
    JSON.parse response.body
  end


  def assert_tag tag
    assert_true @user.tags.include?(tag), "user should have tag: #{tag} but has tags: #{@user.tags}"
  end
  def assert_not_tag tag
    assert_false @user.tags.include?(tag), "user should not have tag: #{tag} but has tags: #{@user.tags}"
  end
end