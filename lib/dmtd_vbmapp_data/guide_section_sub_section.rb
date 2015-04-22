require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the retrieving of VB-MAPP Guide section sub_sections from the VB-MAPP Data Server.
  class GuideSectionSubSection

    attr_reader :client
    attr_reader :chapter_num
    attr_reader :section_num
    attr_reader :sub_section_num

    # Creates an accessor for the VB-MAPP Guide Chapter Section on the VB-MAPP Data Server
    #
    # This method does *not* block, simply creates an accessor and returns
    #
    # Params:
    # +client+:: a client instance
    # +chapter_num+:: the number (index) of the chapter in the Guide's index array
    # +section_num+:: the number (index) of the section in the chapter's sections array
    # +sub_section_num+:: the number (index) of the sub_section in the range (0..subsection_count)
    def initialize(opts)
      @client = opts.fetch(:client)
      @chapter_num = opts.fetch(:chapter_num)
      @section_num = opts.fetch(:section_num)
      @sub_section_num = opts.fetch(:sub_section_num)
    end

    def section_title
      retrieve_guide_sub_section[:sectionTitle]
    end

    def section_short_title
      retrieve_guide_sub_section[:sectionShortTitle]
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
        response = RequestHelpers::get_authorized(end_point: GuideSectionSubSection::end_point, params: params, client_id: @client.id, client_code: @client.code)
        proc_response = process_response(response)
        json = proc_response[:json]
        server_response_code = proc_response[:code]

        @guide_sub_section = json
        # result = server_response_code if json.nil?
      end

      @guide_sub_section
    end

    def process_response(response)
      json = nil
      server_response_code = response.code.to_i

      if server_response_code == 200
        json_body = Hashie.symbolize_keys!(JSON.parse(response.body))
        json = json_body[:response]
      end

      { json: json, code: server_response_code }
    end
  end

end