require 'spec_helper'

module DmtdVbmappData

  describe GuideChapterSection do

    it 'can be created' do
      section = GuideChapterSection.new(client: client, chapter_num: 1, section_num:1, section_index_json: section_index_json)
      expect(section).to_not be nil
      expect(section.chapter_num).to eq(1)
      expect(section.section_num).to eq(1)
      expect(section.section_title).to eq(section_index_json[:sectionTitle])
      expect(section.section_short_title).to eq(section_index_json[:sectionShortTitle])
    end

    it 'can pull section content' do
      section_content = client.guide.chapters[1].sections[0].section_content

      expect(section_content).to_not be nil
      expect(section_content.is_a?(String)).to eq(true)
    end

    it 'has sub-sections' do
      sub_sections = client.guide.chapters[1].sections[5].sub_sections

      expect(sub_sections).to_not be nil
      expect(sub_sections.is_a?(Array)).to eq(true)
      expect(sub_sections.size).to be > 0
    end

    private

    def client
      Client.new(date_of_birth: Date.today, gender: DmtdVbmappData::GENDER_FEMALE)
    end

    def section_index_json
      {
          subsection_count: 0,
          sectionShortTitle: 'bar',
          sectionTitle: 'foo'
      }
    end

  end

end