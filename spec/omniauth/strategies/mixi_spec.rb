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

  describe 'Authorize params' do
    it 'should include the MINIMUM_SCOPE if info_level is min' do
      request = stub('Request')
      request.stub!(:params).and_return({})
      args = [nil, nil, {:info_level => :min}]
      target = OmniAuth::Strategies::Mixi.new(nil, *args).tap do |strategy|
        strategy.stub!(:request).and_return(request)
        strategy.stub!(:session).and_return({})
      end
      target.authorize_params[:scope].should == 'r_profile'
    end

    it 'should include the BASIC_SCOPE if info_level is not specified' do
      request = stub('Request')
      request.stub!(:params).and_return({})
      args = [nil, nil, {}]
      target = OmniAuth::Strategies::Mixi.new(nil, *args).tap do |strategy|
        strategy.stub!(:request).and_return(request)
        strategy.stub!(:session).and_return({})
      end
      target.authorize_params[:scope].should ==
        'r_profile r_profile_name r_profile_location r_profile_about_me'
    end

    it 'should include the special :scope parameter' do
      request = stub('Request')
      request.stub!(:params).and_return({})
      args = [nil, nil, {:scope => 'r_profile r_voice'}]
      target = OmniAuth::Strategies::Mixi.new(nil, *args).tap do |strategy|
        strategy.stub!(:request).and_return(request)
        strategy.stub!(:session).and_return({})
      end
      target.authorize_params[:scope].should == 'r_profile r_voice'
    end

    it 'should include the display parameter' do
      request = stub('Request')
      request.stub!(:params).and_return({})
      args = [nil, nil, {:display => 'touch'}]
      target = OmniAuth::Strategies::Mixi.new(nil, *args).tap do |strategy|
        strategy.stub!(:request).and_return(request)
        strategy.stub!(:session).and_return({})
      end
      target.authorize_params[:display].should == 'touch'
    end

    it 'should include the display parameter via request' do
      request = stub('Request')
      request.stub!(:params).and_return({'display' => 'touch'})
      args = [nil, nil, {}]
      target = OmniAuth::Strategies::Mixi.new(nil, *args).tap do |strategy|
        strategy.stub!(:request).and_return(request)
        strategy.stub!(:session).and_return({})
      end
      target.authorize_params[:display].should == 'touch'
    end
  end

  describe 'User info' do
    before do
      options = mock('options')
      options.should_receive('[]=').exactly(8)
      access_token = mock('access_token')
      access_token.should_receive(:options).exactly(8).and_return(options)
      api_result = mock('api_result')
      api_result.should_receive(:parsed).and_return(parsed_entry)
      access_token
        .should_receive(:get)
        .with('/2/people/@me/@self?fields=@all')
        .and_return(api_result)
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

  describe 'User info without name' do
    before do
      options = mock('options')
      options.should_receive('[]=').exactly(11)
      access_token = mock('access_token')
      access_token.should_receive(:options).exactly(11).and_return(options)
      api_result = mock('api_result')
      api_result
        .should_receive(:parsed)
        .and_return(parsed_entry_without_name)
      access_token
        .should_receive(:get)
        .with('/2/people/@me/@self?fields=@all')
        .and_return(api_result)
      subject.access_token = access_token
    end

    it 'should have correct info' do
      user_info = subject.info
      user_info['nickname'].should == 'displayName1'
      user_info['name'].should == 'displayName1'
      user_info['first_name'].should be_nil
      user_info['last_name'].should be_nil
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
      access_token
        .should_receive(:get)
        .with('/2/people/@me/@self?fields=@all')
        .and_return(api_result)
      subject.access_token = access_token
    end

    it 'should have correct uid' do
      subject.uid.should == 'id1'
    end
  end

  describe 'Extra info' do
    before do
      options = mock('options')
      options.should_receive('[]=').exactly(1)
      access_token = mock('access_token')
      access_token.should_receive(:options).exactly(1).and_return(options)
      api_result = mock('api_result')
      api_result.should_receive(:parsed).and_return(parsed_entry)
      access_token
        .should_receive(:get)
        .with('/2/people/@me/@self?fields=@all')
        .and_return(api_result)
      subject.access_token = access_token
    end

    it 'should have correct extra' do
      extra_info = subject.extra['raw_info']
      extra_info.should_not be_nil
      extra_info['id'].should == 'id1'
      extra_info['displayName'].should == 'displayName1'
      extra_info['name'].should_not be_nil
      extra_info['name']['givenName'].should == 'givenName1'
      extra_info['name']['familyName'].should == 'familyName1'
      extra_info['aboutMe'].should == 'aboutMe1'
      extra_info['addresses'].should_not be_nil
      extra_info['addresses'].should have(1).items
      extra_info['addresses'][0]['region'].should == 'region1'
      extra_info['addresses'][0]['type'].should == 'location'
      extra_info['addresses'][0]['locality'].should == 'locality1'
      extra_info['profileUrl'].should == 'profileUrl1'
      extra_info['thumbnailUrl'].should == 'thumbnailUrl1'
    end
  end
end

def parsed_entry
  {
    'entry' => {
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
end

def parsed_entry_without_name
  hash = parsed_entry
  hash['entry'].delete('name')
  hash
end
