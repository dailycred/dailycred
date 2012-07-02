require 'spec_helper'

describe OmniAuth::Strategies::Dailycred do
  subject do
    OmniAuth::Strategies::Dailycred.new(nil, @options || {})
  end
  
  
  describe '#client' do
      it 'should have the correct dwolla site' do
        subject.client.site.should eq("https://auth.dailycred.com")
      end
      it 'should have the correct authorization url' do
        subject.client.options[:authorize_url].should eq("https://auth.dailycred.com/oauth/authorize")
      end
      
      it 'should have the correct token url' do
        subject.client.options[:token_url].should eq('https://auth.dailycred.com/oauth/tokeninfo')
      end
  end
  
end