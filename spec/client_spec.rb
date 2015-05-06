require 'spec_helper'

module DmtdVbmappData

  describe Client do

    it 'can be created without a language' do
      client = Client.new(date_of_birth: Date.today, gender: GENDER_MALE)
      expect(client).to_not be nil
      expect(client.server_response_code).to eq(200)
    end

    it 'can be created with language' do
      AVAILABLE_LANGUAGES.each do |language|
        client = Client.new(date_of_birth: Date.today, gender: GENDER_MALE, language: language)
        expect(client).to_not be nil
        expect(client.server_response_code).to eq(200)
        expect(client.language).to eq(language)
      end
    end

    it 'can retrieve existing clients' do
      clients = Client.retrieve_clients

      expect(clients).to_not be nil
      expect(clients.is_a?(Array)).to eq(true)
      expect(clients.size).to be > 0

      clients.each do |client|
        expect(client.server_response_code).to eq(200)
      end if clients.is_a?(Array)
    end

    it 'can access the guide' do
      Client.retrieve_clients.each do |client|
        expect(client.guide).to_not be_nil
        expect(client.guide.is_a?(DmtdVbmappData::Guide)).to eq(true)
      end
    end

    it 'can access the vbmapp' do
      Client.retrieve_clients.each do |client|
        expect(client.vbmapp).to_not be_nil
        expect(client.vbmapp.is_a?(DmtdVbmappData::Vbmapp)).to eq(true)
      end
    end

  end

end