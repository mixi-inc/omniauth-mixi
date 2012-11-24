require 'spec_helper'

describe OmniAuth::Strategies::Mixi do
  subject do
    OmniAuth::Strategies::Mixi.new({})
  end

  context 'Client options' do
    before(:all) do
      @options = subject.options.client_options
    end

    it 'should have correct site' do
      @options.site.should == 'https://api.mixi-platform.com/2'
    end

    it 'should have correct authorize url' do
      @options.authorize_url.should == 'https://mixi.jp/connect_authorize.pl'
    end

    it 'should have correct token url' do
      @options.token_url.should == 'https://api.mixi-platform.com/2/token'
    end
  end
end
