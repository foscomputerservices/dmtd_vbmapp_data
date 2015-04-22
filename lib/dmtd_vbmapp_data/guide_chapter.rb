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
    # This method does *not* block, simply creates an accessor and returns
    #
    # Params:
    # +client+:: a client instance
    # +chapter_num+:: the number (index) of the chapter in the Guide's index array
    # +chapter_index_json+:: the guide index json for the chapter
    def initialize(opts)
      @client = opts.fetch(:client)
      @chapter_num = opts.fetch(:chapter_num)

      index_json = opts.fetch(:chapter_index_json)
      @chapter_title = index_json[:chapterTitle]
      @chapter_short_title = index_json[:chapterShortTitle]
      @sections_index = index_json[:sections]
    end

    # Returns the preamble of the Guide's chapter
    #
    # This method *does* block as the content is retrieved
    def chapter_preamble
      @chapter_preamble = retrieve_guide_chapter[:chapterPreamble] if @chapter_preamble.nil?

      @chapter_preamble
    end

    # Returns the VB-MAPP Guide chapter sections
    #
    # This method does *not* block on server access
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
      response = RequestHelpers::get_authorized(end_point: GuideChapter::end_point, params: params, client_id: @client.id, client_code: @client.code)
      proc_response = RequestHelpers::process_json_response(response)
      json = proc_response[:json]
      server_response_code = proc_response[:code]

      result = json
      result = server_response_code if json.nil?

      result
    end

  end

end