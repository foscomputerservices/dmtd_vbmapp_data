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
    # @note This method does *not* block, simply creates an accessor and returns
    #
    # @option opts [Client] :client A client instance
    # @option opts [Integer] :chapter_num The number (index 0..n) of the chapter in the Guide's index array
    # @option opts [Integer] :section_num The number (index 0..n) of the section in the chapter's sections array
    # @option opts [Integer] :sub_section_num The number (index 0..n) of the subSection in section's subSections array
    # @option opts [Hash] :sub_section_index_json The guide index json for the subSection in the format described at
    #     {https://datamtd.atlassian.net/wiki/pages/viewpage.action?pageId=18710558 1/guide/index REST api - SubSection Fields}
    def initialize(opts)
      @client = opts.fetch(:client)
      @chapter_num = opts.fetch(:chapter_num)
      @section_num = opts.fetch(:section_num)
      @sub_section_num = opts.fetch(:sub_section_num)

      sub_section_index_json = opts.fetch(:sub_section_index_json)
      @section_title = sub_section_index_json[:sectionTitle]
      @section_short_title = sub_section_index_json[:sectionShortTitle]
    end

    # @note This method *does* block as the content is retrieved
    #
    # @return [String] The content of the Guide's sub section
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