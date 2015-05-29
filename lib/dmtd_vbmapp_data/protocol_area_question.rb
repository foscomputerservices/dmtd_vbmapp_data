require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the retrieving of VB-MAPP Area Question on the VB-MAPP Data Server.
  class ProtocolAreaQuestion

    # @!attribute [r] client
    #   @return [Client] the associated client
    attr_reader :client

    # @!attribute [r] area
    #   @return [Symbol] the area of the question (e.g. :milestones, :barriers, :transitions, :eesa)
    attr_reader :area

    # @!attribute [r] group
    #   @return [Symbol] the group of the question (e.g. :mand, :tact, :group1, etc.)
    attr_reader :group

    # @!attribute [r] definition
    #   @return [String] the formal definition for the question
    attr_reader :definition

    # @!attribute [r] example
    #   @return [String] an example of administering the question
    attr_reader :example

    # @!attribute [r] materials
    #   @return [String] the materials required to administer the question
    attr_reader :materials

    # @!attribute [r] objective
    #   @return [String] The objective of the question
    attr_reader :objective

    # @!attribute [r] number
    #   @return [Integer] the question number (0...n)
    attr_reader :number

    # @!attribute [r] text
    #   @return [String] the text of the question itself
    attr_reader :text

    # @!attribute [r] title
    #   @return [String] a title to display at the top of a grid column
    attr_reader :title

    # Creates an accessor for the VB-MAPP Area Question on the VB-MAPP Data Server
    #
    # @note This method does *not* block, simply creates an accessor and returns
    #
    # @option opts [Client] :client A client instance
    # @option opts [String | Symbol] :area The vbmapp area of the group ('milestones', 'barriers', 'transitions', 'eesa')
    # @option opts [String | Symbol] :group The vbmapp area group name (i.e. 'mand', 'tact', 'group1', etc.)
    # @option opts [Hash]   :question_json The vbmapp question json for the question in the format described at
    #     {https://datamtd.atlassian.net/wiki/pages/viewpage.action?pageId=18710549 /1/protocol/area_question - GET REST api - Fields}
    def initialize(opts)
      @client = opts.fetch(:client)
      @area = opts.fetch(:area).to_sym
      @group = opts.fetch(:group).to_sym
      question_json = opts.fetch(:question_json)

      guide_content_json = question_json[:guideContent] || {}
      @definition = guide_content_json[:definition] || ''
      @objective = guide_content_json[:objective] || ''

      @example = question_json[:example] || guide_content_json[:examples]
      @materials = question_json[:materials] || guide_content_json[:materials]
      @number = question_json[:number].to_i
      @text = question_json[:text]
      @title = question_json[:title] || guide_content_json[:title]
      @responses_json_array = question_json[:responses]
    end

    # @note This method does *not* block.
    #
    # @return [Array<ProtocolAreaResponse>] all of the VB-MAPP question's possible responses
    def responses
      if @responses.nil?

        # If we don't have responses, get them from the area
        if @responses_json_array.nil?
          @responses = client.vbmapp.areas.select { |client_area| client_area.area == area}[0].responses
        else
          @responses = @responses_json_array.map { |response_json| ProtocolAreaResponse.new(area: area, response_json: response_json) }
        end
      end

      @responses
    end

  end

end