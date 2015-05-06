require 'spec_helper'

module DmtdVbmappData

  describe GuideChapterSection do

    it 'can be created' do
      section = GuideSectionSubSection.new(client: client, chapter_num: 1, section_num:5, sub_section_num: 1, sub_section_index_json: sub_section_index_json)
      expect(section).to_not be nil
      expect(section.chapter_num).to eq(1)
      expect(section.section_num).to eq(5)
      expect(section.sub_section_num).to eq(1)
    end

    it 'can pull sub section content' do
      prev_section_content = nil

      AVAILABLE_LANGUAGES.each do |language|
        section_content = client(language: language).guide.chapters[1].sections[5].sub_sections[1].section_content

        expect(section_content).to_not be nil
        expect(section_content.is_a?(String)).to eq(true)

        expect(section_content).to_not eq(prev_section_content) unless prev_section_content.nil?

        prev_section_content = section_content
      end
    end

    private

    def client(opts = {})
      language = opts.fetch(:language, nil)

      Client.new(id: 57, language: language)
    end

    def sub_section_index_json
      {
          sectionShortTitle: 'foo',
          sectionTitle: 'bar'
      }
    end

  end

end
