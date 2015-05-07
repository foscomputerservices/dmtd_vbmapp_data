require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the retrieving of VB-MAPP Guide chapter sections from the VB-MAPP Data Server.
  class VbmappAreaResponse

    attr_reader :area
    attr_reader :score
    attr_reader :text
    attr_reader :description

    # Creates an accessor for the VB-MAPP Area Question on the VB-MAPP Data Server
    #
    # @note This method does *not* block, simply creates an accessor and returns
    #
    # @option opts [Client] :client A client instance
    # @option opts [String] :area The vbmapp area of the group ('milestones', 'barriers', 'transitions', 'eesa')
    # @option opts [Hash]   :response_json The vbmapp question json for the question in the format described at
    #     {https://datamtd.atlassian.net/wiki/pages/viewpage.action?pageId=18710549 /1/vbmapp/area_question - GET REST api - response}
    def initialize(opts)
      @area = opts.fetch(:area)

      response_json = opts.fetch(:response_json)
      @score = response_json[:score]
      @text = response_json[:text]
      @description = response_json[:description]
    end

  end

end