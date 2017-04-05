require 'spec_helper'

module DmtdVbmappData

  describe GuideChapterSection do

    prev_content = []

    AVAILABLE_LANGUAGES.each do |language|

      context "Language: #{language}" do
        let(:client) { Client.new(id: VBMDATA_TEST_CLIENT_ID, language: language) }

        it 'can be created' do
          section = GuideChapterSection.new(client: client, chapter_num: 1, section_num:1, section_index_json: section_index_json)
          expect(section).to_not be nil
          expect(section.chapter_num).to eq(1)
          expect(section.section_num).to eq(1)
          expect(section.title).to eq(section_index_json[:title])
        end

        it 'can pull section content' do
          content = client.guide.chapters[1].sections[0].content

          expect(content).to_not be nil
          expect(content.is_a?(String)).to eq(true)

          expect(prev_content).to_not include(content)

          prev_content << content
        end

      end
    end

    private
    
    def section_index_json
      {
        subSections: [],
        sectionShortTitle: 'bar',
        sectionTitle: 'foo'
      }
    end

  end

end