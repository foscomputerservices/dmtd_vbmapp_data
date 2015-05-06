require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the retrieving of VB-MAPP Guide chapter sections from the VB-MAPP Data Server.
  class GuideChapterSection

    attr_reader :client
    attr_reader :chapter_num
    attr_reader :section_num
    attr_reader :section_title
    attr_reader :section_short_title

    # Creates an accessor for the VB-MAPP Guide Chapter Section on the VB-MAPP Data Server
    #
    # This method does *not* block, simply creates an accessor and returns
    #
    # Params:
    # +client+:: a client instance
    # +chapter_num+:: the number (index) of the chapter in the Guide's index array
    # +section_num+:: the number (index) of the section in the chapter's sections array
    # +section_index_json+:: the guide index json for the chapter
    def initialize(opts)
      @client = opts.fetch(:client)
      @chapter_num = opts.fetch(:chapter_num)
      @section_num = opts.fetch(:section_num)

      index_json = opts.fetch(:section_index_json)
      @section_title = index_json[:sectionTitle]
      @section_short_title = index_json[:sectionShortTitle]
      @sub_sections_index = index_json[:subSections]
    end

    # Returns the content of the Guide's chapter section
    #
    # This method *does* block as the content is retrieved
    def section_content
      @section_content = retrieve_guide_section[:sectionContent] if @section_content.nil?

      @section_content
    end

    # Returns the VB-MAPP Guide section's sub_sections
    def sub_sections
      @sub_sections = @sub_sections_index.map.with_index do |sub_section_index_json, sub_section_num|
        GuideSectionSubSection.new(client: client, chapter_num: chapter_num, section_num: section_num, sub_section_num: sub_section_num, sub_section_index_json: sub_section_index_json)
      end if @sub_sections.nil?

      @sub_sections
    end

    private

    def self.end_point
      '1/guide/section'
    end

    def retrieve_guide_section
      params = {
          chapter_num: chapter_num,
          section_num: section_num
      }
      response = RequestHelpers::get_authorized(end_point: GuideChapterSection::end_point, params: params, client_id: @client.id, client_code: @client.code, language: client.language)
      proc_response = RequestHelpers::process_json_response(response)
      json = proc_response[:json]
      server_response_code = proc_response[:code]

      result = json
      result = server_response_code if json.nil?

      result
    end
  end

end