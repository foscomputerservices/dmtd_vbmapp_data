require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the retrieving of VB-MAPP Guide chapters from the VB-MAPP Data Server.
  class GuideChapter

    attr_reader :client
    attr_reader :chapter_num
    attr_reader :chapter_title
    attr_reader :chapter_short_title

    # Creates an accessor for the VB-MAPP Guide Chapter on the VB-MAPP Data Server
    #
    # @note This method does *not* block, simply creates an accessor and returns
    #
    # @option opts [Client] :client A client instance
    # @option opts [Integer] :chapter_num The number (index 0..n) of the chapter in the Guide's index array
    # @option opts [Hash] :chapter_index_json The guide index json for the chapter in the format described at
    #     {https://datamtd.atlassian.net/wiki/pages/viewpage.action?pageId=18710558 1/guide/index REST api - Chapter Fields}
    def initialize(opts)
      @client = opts.fetch(:client)
      @chapter_num = opts.fetch(:chapter_num)

      index_json = opts.fetch(:chapter_index_json)
      @chapter_title = index_json[:chapterTitle]
      @chapter_short_title = index_json[:chapterShortTitle]

      @sections_index = index_json[:sections]
    end

    # @note This method *does* block as the content is retrieved
    #
    # @return [String] The preamble of the Guide's chapter
    def chapter_preamble
      @chapter_preamble = retrieve_guide_chapter[:chapterPreamble] if @chapter_preamble.nil?

      @chapter_preamble
    end

    # @note This method does *not* block
    #
    # @return [Array<GuideChapterSection>] all of the the VB-MAPP Guide's {GuideChapterSection} instances
    def sections
      @sections = @sections_index.map.with_index { |section_index_json, section_num|
        GuideChapterSection.new(client: client, chapter_num: chapter_num, section_num: section_num, section_index_json: section_index_json)
      } if @sections.nil?

      @sections
    end

    private

    def self.end_point
      '1/guide/chapter'
    end

    def retrieve_guide_chapter
      params = {
          chapter_num: chapter_num
      }
      response = RequestHelpers::get_authorized(end_point: GuideChapter::end_point, params: params, client_id: @client.id, client_code: @client.code, language:client.language)
      proc_response = RequestHelpers::process_json_response(response)
      json = proc_response[:json]
      server_response_code = proc_response[:code]

      result = json
      result = server_response_code if json.nil?

      result
    end

  end

end