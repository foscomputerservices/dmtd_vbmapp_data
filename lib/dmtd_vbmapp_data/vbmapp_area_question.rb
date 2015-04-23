require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the retrieving of VB-MAPP Guide chapter sections from the VB-MAPP Data Server.
  class VbmappAreaQuestion

    attr_reader :client
    attr_reader :area
    attr_reader :group
    attr_reader :example
    attr_reader :materials
    attr_reader :question_number
    attr_reader :question_text

    # Creates an accessor for the VB-MAPP Area Question on the VB-MAPP Data Server
    #
    # This method does *not* block, simply creates an accessor and returns
    #
    # Params:
    # +client+:: a client instance
    # +area+:: the vbmapp area
    # +group+:: the vbmapp area group name
    # +question_json+:: The JSON that describes a VB-MAPP area question
    def initialize(opts)
      @client = opts.fetch(:client)
      @area = opts.fetch(:area)
      @group = opts.fetch(:group)

      question_json = opts.fetch(:question_json)
      @example = question_json[:example]
      @guide_content = question_json[:guideContent]
      @materials = question_json[:materials]
      @question_number = question_json[:questionNumber]
      @question_text = question_json[:questionText]
      @responses_json_array = question_json[:responses]
    end

    # Returns the VB-MAPP question's possible responses.
    def responses
      if @responses.nil?

        # If we don't have responses, get them from the area
        if @responses_json_array.nil?
          @responses = client.vbmapp.areas.select { |client_area| client_area.area == area}[0].responses
        else
          @responses = @responses_json_array.map { |response_json| VbmappAreaResponse.new(area: area, response_json: response_json) }
        end
      end

      # @levels = @levels.map { |sub_section_num|
      #   GuideSectionSubSection.new(client: client, chapter_num: chapter_num, section_num: section_num, sub_section_num: sub_section_num)
      # } if @levels.nil?
      #
      # @levels

      @responses
    end

  end

end