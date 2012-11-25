require 'spec_helper'

describe OmniAuth::Strategies::Mixi do
  subject do
    OmniAuth::Strategies::Mixi.new({})
  end

  describe 'Client options' do
    before(:all) do
      @options = subject.options.client_options
    end

    it 'should have correct site' do
      @options.site.should == 'https://api.mixi-platform.com'
    end

    it 'should have correct authorize url' do
      @options.authorize_url.should == 'https://mixi.jp/connect_authorize.pl'
    end

    it 'should have correct token url' do
      @options.token_url.should == 'https://api.mixi-platform.com/2/token'
    end
  end

  describe 'User info' do
    before do
      options = mock('options')
      options.should_receive('[]=').exactly(8)
      access_token = mock('access_token')
      access_token.should_receive(:options).exactly(8).and_return(options)
      parsed = {'entry' => {
          'id' => 'id1',
          'displayName' => 'displayName1',
          'name' => {
            'givenName' => 'givenName1',
            'familyName' => 'familyName1'
          },
          'aboutMe' => 'aboutMe1',
          'addresses' => [{
                            'region' => 'region1',
                            'type' => 'location',
                            'locality' => 'locality1'
                          }],
          'profileUrl' => 'profileUrl1',
          'thumbnailUrl' => 'thumbnailUrl1'
        }
      }
      api_result = mock('api_result')
      api_result.should_receive(:parsed).and_return(parsed)
      access_token.should_receive(:get).and_return(api_result)
      subject.access_token = access_token
    end

    it 'should have correct info' do
      user_info = subject.info
      user_info['nickname'].should == 'displayName1'
      user_info['name'].should == 'familyName1 givenName1'
      user_info['first_name'].should == 'givenName1'
      user_info['last_name'].should == 'familyName1'
      user_info['description'].should == 'aboutMe1'
      user_info['location'].should == 'region1locality1'
      user_info['urls'].should_not be_nil
      user_info['urls']['profile'].should == 'profileUrl1'
      user_info['image'].should == 'thumbnailUrl1'
    end
  end

  describe 'User ID' do
    before do
      options = mock('options')
      options.should_receive('[]=')
      access_token = mock('access_token')
      access_token.should_receive(:options).and_return(options)
      parsed = {'entry' => {
          'id' => 'id1'
        }
      }
      api_result = mock('api_result')
      api_result.should_receive(:parsed).and_return(parsed)
      access_token.should_receive(:get).and_return(api_result)
      subject.access_token = access_token
    end

    it 'should have correct uid' do
      subject.uid.should == 'id1'
    end
  end
end
