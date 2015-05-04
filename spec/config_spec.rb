require 'spec_helper'

describe 'DmtdVbmappData.configure' do

  it 'allows setting the server url' do
    old_url = DmtdVbmappData.config[:server_url]

    test_url = 'foo.bar'
    DmtdVbmappData.configure server_url: test_url

    expect(DmtdVbmappData.config[:server_url]).to eq(test_url)

    DmtdVbmappData.configure server_url: old_url
  end

  it 'allows setting the auth token' do
    old_auth_token = DmtdVbmappData.config[:auth_token]

    auth_token = '123456'
    DmtdVbmappData.configure auth_token: auth_token

    expect(DmtdVbmappData.config[:auth_token]).to eq(auth_token)

    DmtdVbmappData.configure auth_token: old_auth_token
  end

  it 'allows setting the document type' do
    old_doc_type = DmtdVbmappData.config[:document_type]

    doc_type = 'my_doc_type'
    DmtdVbmappData.configure document_type: doc_type

    expect(DmtdVbmappData.config[:document_type]).to eq(doc_type)

    DmtdVbmappData.configure document_type: old_doc_type
  end

  it 'allows setting via YAML file' do
    old_url = DmtdVbmappData.config[:server_url]
    old_auth_token = DmtdVbmappData.config[:auth_token]
    old_doc_type = DmtdVbmappData.config[:document_type]

    DmtdVbmappData.configure_with File.join(__dir__, 'test_config.yaml')

    expect(DmtdVbmappData.config[:server_url]).to eq('foo.bar.zap')
    expect(DmtdVbmappData.config[:auth_token]).to eq('123abc')
    expect(DmtdVbmappData.config[:document_type]).to eq('my_doc_type')

    DmtdVbmappData.configure server_url: old_url
    DmtdVbmappData.configure auth_token: old_auth_token
    DmtdVbmappData.configure document_type: old_doc_type
  end

end
