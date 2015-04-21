require 'spec_helper'

describe 'configure' do

  it 'allows setting the server url' do
    test_url = 'foo.bar'
    DmtdVbmappData.configure server_url: test_url

    expect(DmtdVbmappData.config[:server_url]).to eq(test_url)
  end

  it 'allows setting the auth token' do
    auth_token = '123456'
    DmtdVbmappData.configure auth_token: auth_token

    expect(DmtdVbmappData.config[:auth_token]).to eq(auth_token)
  end

  it 'allows setting via YAML file' do
    DmtdVbmappData.configure_with File.join(__dir__, 'test_config.yaml')

    expect(DmtdVbmappData.config[:server_url]).to eq('foo.bar.zap')
    expect(DmtdVbmappData.config[:auth_token]).to eq('123abc')
  end

end
