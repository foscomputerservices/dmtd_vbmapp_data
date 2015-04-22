require 'spec_helper'

module DmtdVbmappData

  describe GuideChapter do

    it 'can be created' do
      chapter = GuideChapter.new(client: client, chapter_num: 0, chapter_index_json: chapter_index_json)
      expect(chapter).to_not be nil
      expect(chapter.chapter_num).to eq(0)
      expect(chapter.chapter_title).to eq(chapter_index_json[:chapterTitle])
      expect(chapter.chapter_short_title).to eq(chapter_index_json[:chapterShortTitle])
    end

    it 'can pull preamble' do
      chapter_preamble = client.guide.chapters[0].chapter_preamble

      expect(chapter_preamble).to_not be nil
      expect(chapter_preamble.is_a?(String)).to eq(true)
    end

    it 'has sections' do
      sections = client.guide.chapters[1].sections

      expect(sections).to_not be nil
      expect(sections.is_a?(Array)).to eq(true)
      expect(sections.size).to be > 0
    end

    private

    def client
      Client.new(date_of_birth: Date.today, gender: DmtdVbmappData::GENDER_FEMALE)
    end

    def chapter_index_json
      {
          sections: [],
          chapterShortTitle: 'foo',
          chapterTitle: 'bar'
      }
    end

  end

end