require 'spec_helper'

module DmtdVbmappData

  describe Client do

    it 'can be created' do
      opts = {
          date_of_birth: Date.today,
          gender: GENDER_MALE
      }

      client = Client.new(opts)
      expect(client).to_not be nil
      expect(client.server_response_code).to eq(200)
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

  end

end