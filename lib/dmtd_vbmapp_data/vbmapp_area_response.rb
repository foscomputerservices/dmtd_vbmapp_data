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
    # This method does *not* block, simply creates an accessor and returns
    #
    # Params:
    # +area+:: the vbmapp area
    # +response_json+:: the response's json
    def initialize(opts)
      @area = opts.fetch(:area)

      response_json = opts.fetch(:response_json)
      @score = response_json[:score]
      @text = response_json[:text]
      @description = response_json[:description]
    end

  end

end