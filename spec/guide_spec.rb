require 'spec_helper'

module DmtdVbmappData

  describe Guide do

    it 'can be created' do
      client = Client.new(date_of_birth: Date.today, gender: DmtdVbmappData::GENDER_FEMALE)

      expect(Guide.new(client: client)).to_not be nil
    end

    it 'can pull the index' do
      prev_guide = nil

      AVAILABLE_LANGUAGES.each do |language|
        guide = Guide.new(client: Client.new(date_of_birth: Date.today, gender: DmtdVbmappData::GENDER_FEMALE), language: language)

        expect(guide.index).to_not be nil
        expect(guide.index.is_a?(Array)).to eq(true)
        expect(guide).to_not eq(prev_guide) unless prev_guide.nil?

        prev_guide = guide
      end
    end

    it 'can provide chapters' do
      prev_chapters = nil
      AVAILABLE_LANGUAGES.each do |language|
        guide = Guide.new(client: Client.new(date_of_birth: Date.today, gender: DmtdVbmappData::GENDER_FEMALE), language: language)

        expect(guide.chapters).to_not be nil
        expect(guide.chapters.is_a?(Array)).to eq(true)
        guide.chapters.each do |chapter|
          expect(chapter.is_a?(DmtdVbmappData::GuideChapter)).to eq(true)
        end

        expect(guide.chapters).to_not eq(prev_chapters) unless prev_chapters.nil?

        prev_chapters = guide.chapters
      end
    end

  end

end