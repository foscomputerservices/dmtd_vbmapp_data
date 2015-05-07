require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the retrieving of VB-MAPP area information from the VB-MAPP Data Server.
  class VbmappArea

    attr_reader :client
    attr_reader :area

    # Creates an accessor for the VB-MAPP Guide Chapter on the VB-MAPP Data Server
    #
    # @note This method does *not* block, simply creates an accessor and returns
    #
    # @option opts [Client] :client A client instance
    # @option opts [Hash] :area_index_json The vbmapp area index json for the VB-Mapp Area in the format described at
    #     {https://datamtd.atlassian.net/wiki/pages/viewpage.action?pageId=18710543 /1/vbmapp/index - GET REST api - Area Fields}
    def initialize(opts)
      @client = opts.fetch(:client)

      index_json = opts.fetch(:area_index_json)
      @area = index_json[:area]
      @groups_index = index_json[:groups]
    end

    # @note This method does *not* block on server access
    #
    # @return [Array<VbmappAreaGroup>] all of the VB-Mapp's {VbmappAreaGroup} instances
    def groups
      @groups = @groups_index.map.with_index { |group_index_json, group_num|
        VbmappAreaGroup.new(client: client, area: area, group_index_json: group_index_json)
      } if @groups.nil?

      @groups
    end

  end

end