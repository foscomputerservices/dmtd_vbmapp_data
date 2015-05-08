require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the retrieving of VB-MAPP Guide chapter sections from the VB-MAPP Data Server.
  class GuideChapterSection

    # @!attribute [r] client
    #   @return [Client] the associated client
    attr_reader :client

    # @!attribute [r] chapter_num
    #   @return [Integer] the number of the chapter (0..n)
    attr_reader :chapter_num

    # @!attribute [r] section_num
    #   @return [Integer] the number of the section (0..n)
    attr_reader :section_num

    # @!attribute [r]
    #   @return [String] the title of the section
    attr_reader :section_title

    # @!attribute [r]
    #   @return [String] an abbreviated title for the section
    attr_reader :section_short_title

    # Creates an accessor for the VB-MAPP Guide Chapter Section on the VB-MAPP Data Server
    #
    # @note This method does *not* block, simply creates an accessor and returns
    #
    # @option opts [Client] :client A client instance
    # @option opts [Integer] :chapter_num The number (index 0..n) of the chapter in the Guide's index array
    # @option opts [Integer] :section_num The number (index 0..n) of the section in the chapter's sections array
    # @option opts [Hash] :section_index_json The guide index json for the chapter section in the format described at
    #     {https://datamtd.atlassian.net/wiki/pages/viewpage.action?pageId=18710558 1/guide/index REST api - Section Fields}
    def initialize(opts)
      @client = opts.fetch(:client)
      @chapter_num = opts.fetch(:chapter_num).to_i
      @section_num = opts.fetch(:section_num).to_i

      index_json = opts.fetch(:section_index_json)
      @section_title = index_json[:sectionTitle]
      @section_short_title = index_json[:sectionShortTitle]
      @sub_sections_index = index_json[:subSections]
    end

    # @note This method *does* block as the content is retrieved
    #
    # @return [String] The content of the Guide's chapter section
    def section_content
      @section_content = retrieve_guide_section[:sectionContent] if @section_content.nil?

      @section_content
    end

    # @note This method does *not* block
    #
    # @return [Array<GuideSectionSubSection>] The VB-MAPP Guide section's sub_sections
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