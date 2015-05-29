require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the retrieving of VB-MAPP Protocol Area responses from the VB-MAPP Data Server.
  class ProtocolAreaResponse

    # @!attribute [r] area
    #   @return [Symbol] the area of the question (e.g. :milestones, :barriers, :transitions, :eesa)
    attr_reader :area

    # @!attribute [r] score
    #   @return [Integer] the value to store as a score
    attr_reader :score

    # @!attribute [r] text
    #   @return [String] the text to display describing this possible response
    attr_reader :text

    # @!attribute [r] text
    #   @return [String] a description of the score to further help identify its application
    attr_reader :description

    # Creates an accessor for the VB-MAPP Area Question on the VB-MAPP Data Server
    #
    # @note This method does *not* block, simply creates an accessor and returns
    #
    # @option opts [String | Symbol] :area The vbmapp area of the group ('milestones', 'barriers', 'transitions', 'eesa')
    # @option opts [Hash]   :response_json The vbmapp question json for the question in the format described at
    #     {https://datamtd.atlassian.net/wiki/pages/viewpage.action?pageId=18710549 /1/protocol/area_question - GET REST api - response}
    def initialize(opts)
      @area = opts.fetch(:area).to_sym

      response_json = opts.fetch(:response_json)
      @score = response_json[:score]
      @text = response_json[:text]
      @description = response_json[:description]
    end

  end

end