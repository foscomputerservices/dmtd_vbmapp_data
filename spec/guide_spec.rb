require 'spec_helper'

module DmtdVbmappData

  describe Guide do

    it 'can be created' do
      client = Client.new(date_of_birth: Date.today, gender: DmtdVbmappData::GENDER_FEMALE)

      expect(Guide.new(client: client)).to_not be nil
    end

    it 'can pull the index' do
      guide = Guide.new(client: Client.new(date_of_birth: Date.today, gender: DmtdVbmappData::GENDER_FEMALE))

      expect(guide.index).to_not be nil
      expect(guide.index.is_a?(Array)).to eq(true)
    end

    it 'can provide chapters' do
      guide = Guide.new(client: Client.new(date_of_birth: Date.today, gender: DmtdVbmappData::GENDER_FEMALE))

      expect(guide.chapters).to_not be nil
      expect(guide.chapters.is_a?(Array)).to eq(true)
      guide.chapters.each do |chapter|
        expect(chapter.is_a?(DmtdVbmappData::GuideChapter)).to eq(true)
      end
    end

  end

end