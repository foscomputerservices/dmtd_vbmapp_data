require 'spec_helper'

module DmtdVbmappData

  describe GuideChapterSection do

    it 'can be created' do
      section = GuideChapterSection.new(client: client, chapter_num: 1, section_num:1, section_index_json: section_index_json)
      expect(section).to_not be nil
      expect(section.chapter_num).to eq(1)
      expect(section.section_num).to eq(1)
      expect(section.title).to eq(section_index_json[:title])
    end

    it 'can pull section content' do
      prev_content = nil

      AVAILABLE_LANGUAGES.each do |language|
        content = client(language: language).guide.chapters[1].sections[0].content

        expect(content).to_not be nil
        expect(content.is_a?(String)).to eq(true)

        expect(content).to_not eq(prev_content) unless prev_content.nil?

        prev_content = content
      end
    end

    private

    def client(opts = {})
      language = opts.fetch(:language, nil)

      Client.new(id: VBMDATA_TEST_CLIENT_ID, language: language)
    end

    def section_index_json
      {
          subSections: [],
          sectionShortTitle: 'bar',
          sectionTitle: 'foo'
      }
    end

  end

end