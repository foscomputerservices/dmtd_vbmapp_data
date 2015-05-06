require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the retrieving of VB-MAPP Guide section sub_sections from the VB-MAPP Data Server.
  class GuideSectionSubSection

    attr_reader :client
    attr_reader :chapter_num
    attr_reader :section_num
    attr_reader :sub_section_num
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
    # +sub_section_num+:: the number (index) of the sub_section in the range (0..subsection_count)
    # +sub_section_index_json+:: the guide index json for the chapter
    def initialize(opts)
      @client = opts.fetch(:client)
      @chapter_num = opts.fetch(:chapter_num)
      @section_num = opts.fetch(:section_num)
      @sub_section_num = opts.fetch(:sub_section_num)

      sub_section_index_json = opts.fetch(:sub_section_index_json)
      @section_title = sub_section_index_json[:sectionTitle]
      @section_short_title = sub_section_index_json[:sectionShortTitle]
    end

    # Returns the content of the Guide's chapter section
    #
    # This method *does* block as the content is retrieved
    def section_content
      retrieve_guide_sub_section[:sectionContent]
    end

    private

    def self.end_point
      '1/guide/sub_section'
    end

    def retrieve_guide_sub_section
      if @guide_sub_section.nil?
        params = {
            chapter_num: chapter_num,
            section_num: section_num,
            sub_section_num: sub_section_num
        }
        response = RequestHelpers::get_authorized(end_point: GuideSectionSubSection::end_point, params: params, client_id: @client.id, client_code: @client.code, language: client.language)
        proc_response = RequestHelpers::process_json_response(response)
        json = proc_response[:json]
        server_response_code = proc_response[:code]

        @guide_sub_section = json
        # result = server_response_code if json.nil?
      end

      @guide_sub_section
    end
  end

end