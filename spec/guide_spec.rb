require 'spec_helper'

module DmtdVbmappData

  describe Guide do

    it 'can be created' do
      client = Client.new(date_of_birth: Date.today, gender: DmtdVbmappData::GENDER_FEMALE)

      expect(Guide.new(client: client)).to_not be nil
    end

    it 'can provide chapters' do
      prev_chapters = nil
      AVAILABLE_LANGUAGES.each do |language|
        guide = Guide.new(client: Client.new(date_of_birth: Date.today, gender: DmtdVbmappData::GENDER_FEMALE, language: language))

        expect(guide.chapters).to_not be nil
        expect(guide.chapters.is_a?(Array)).to eq(true)
        guide.chapters.each do |chapter|
          expect(chapter.is_a?(DmtdVbmappData::GuideChapter)).to eq(true)
          expect(chapter.title).to eq("CHAPTER 1") if language == 'en' && chapter.chapter_num == 1
          expect(chapter.title).to eq("CAPÍTULO 1") if language == 'es' && chapter.chapter_num == 1
          expect(chapter.title).to eq("CHAPITRE 1") if language == 'fr' && chapter.chapter_num == 1
        end

        expect(guide.chapters).to_not eq(prev_chapters) unless prev_chapters.nil?

        prev_chapters = guide.chapters
      end
    end

    it 'can recover from expiry' do
      guide = Guide.new(client: Client.new(date_of_birth: Date.today, gender: DmtdVbmappData::GENDER_FEMALE), language: AVAILABLE_LANGUAGES[0])
      expect(guide.chapters).to_not be nil

      guide.expire_cache force: true
      expect(guide.chapters).to_not be nil
    end
  end

end