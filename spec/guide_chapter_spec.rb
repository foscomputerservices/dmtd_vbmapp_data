require 'spec_helper'

module DmtdVbmappData

  describe GuideChapter do

    it 'can be created' do
      chapter = GuideChapter.new(client: client, chapter_num: 0, chapter_index_json: chapter_index_json)
      expect(chapter).to_not be nil
      expect(chapter.chapter_num).to eq(0)
      expect(chapter.title).to eq(chapter_index_json[:title])
    end

    it 'can pull content' do
      prev_content = nil

      AVAILABLE_LANGUAGES.each do |language|
        content = client(language: language).guide.chapters[0].content

        expect(content).to_not be nil
        expect(content.is_a?(String)).to eq(true)

        expect(content).to_not eq(prev_content) unless prev_content.nil?

        prev_content = content
      end
    end

    it 'has sections' do
      sections = client.guide.chapters[1].sections

      expect(sections).to_not be nil
      expect(sections.is_a?(Array)).to eq(true)
      expect(sections.size).to be > 0
    end

    it 'can pull html content' do
      save_and_set_doc_type new_doc_type: 'html'

      chapter = GuideChapter.new(client: client, chapter_num: 0, chapter_index_json: chapter_index_json)
      expect(chapter.content.include?('<p>')).to be true

      restore_doc_type
    end

    it 'can pull text content' do
      save_and_set_doc_type new_doc_type: 'text'

      chapter = GuideChapter.new(client: client, chapter_num: 0, chapter_index_json: chapter_index_json)
      expect(chapter.content.include?('<p>')).to be false

      restore_doc_type
    end

    private

    def client(opts = {})
      language = opts.fetch(:language, nil)

      Client.new(id: VBMDATA_TEST_CLIENT_ID, language: language)
    end

    def chapter_index_json
      {
          sections: [],
          chapterShortTitle: 'foo',
          chapterTitle: 'bar'
      }
    end

    def save_and_set_doc_type(new_doc_type:)

      @old_doc_type = DmtdVbmappData.config[:document_type]

      DmtdVbmappData.configure document_type: new_doc_type
    end

    def restore_doc_type
      DmtdVbmappData.configure document_type: @old_doc_type
    end

  end

end