require 'spec_helper'

module DmtdVbmappData

  describe GuideChapterSection do

    it 'can be created' do
      section = GuideSectionSubSection.new(client: client, chapter_num: 1, section_num:5, sub_section_num: 1)
      expect(section).to_not be nil
      expect(section.chapter_num).to eq(1)
      expect(section.section_num).to eq(5)
      expect(section.sub_section_num).to eq(1)
    end

    it 'can pull sub section content' do
      section_content = client.guide.chapters[1].sections[5].sub_sections[1].section_content

      expect(section_content).to_not be nil
      expect(section_content.is_a?(String)).to eq(true)
    end

    it 'can pull sub section short title' do
      section_short_title = client.guide.chapters[1].sections[5].sub_sections[1].section_short_title

      expect(section_short_title).to_not be nil
      expect(section_short_title.is_a?(String)).to eq(true)
    end

    it 'can pull sub section title' do
      section_title = client.guide.chapters[1].sections[5].sub_sections[1].section_title

      expect(section_title).to_not be nil
      expect(section_title.is_a?(String)).to eq(true)
    end

    private

    def client
      Client.new(id: 57)
    end
  end

end
