require 'spec_helper'

module DmtdVbmappData

  describe Vbmapp do

    it 'can be created' do
      client = Client.new(date_of_birth: Date.today, gender: DmtdVbmappData::GENDER_FEMALE)

      expect(Vbmapp.new(client: client)).to_not be nil
    end

    it 'can pull the index' do
      vbmapp = Vbmapp.new(client: Client.new(date_of_birth: Date.today, gender: DmtdVbmappData::GENDER_FEMALE))

      expect(vbmapp.index).to_not be nil
      expect(vbmapp.index.is_a?(Array)).to eq(true)
    end

    it 'can provide areas' do
      vbmapp = Vbmapp.new(client: Client.new(date_of_birth: Date.today, gender: DmtdVbmappData::GENDER_FEMALE))

      expect(vbmapp.areas).to_not be nil
      expect(vbmapp.areas.is_a?(Array)).to eq(true)
      vbmapp.areas.each do |chapter|
        expect(chapter.is_a?(DmtdVbmappData::VbmappArea)).to eq(true)
      end
    end

  end

end