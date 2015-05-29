require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the retrieving of VB-MAPP Protocol Area information from the VB-MAPP Data Server.
  class ProtocolArea

    # @!attribute [r] client
    #   @return [Client] the associated client
    attr_reader :client

    # @!attribute [r] area
    #   @return [Symbol] the area of the question (e.g. :milestones, :barriers, :transitions, :eesa)
    attr_reader :area

    # Creates an accessor for the VB-MAPP Guide Chapter on the VB-MAPP Data Server
    #
    # @note This method does *not* block, simply creates an accessor and returns
    #
    # @option opts [Client] :client A client instance
    # @option opts [Hash] :area_index_json The vbmapp area index json for the VB-Mapp Area in the format described at
    #     {https://datamtd.atlassian.net/wiki/pages/viewpage.action?pageId=18710543 /1/protocol/index - GET REST api - Area Fields}
    def initialize(opts)
      @client = opts.fetch(:client)

      index_json = opts.fetch(:area_index_json)
      @area = index_json[:area].to_sym
      @groups_index = index_json[:groups]
    end

    # @note This method does *not* block on server access
    #
    # @return [Array<ProtocolAreaGroup>] all of the VB-Mapp's {ProtocolAreaGroup} instances
    def groups
      @groups = @groups_index.map.with_index do |group_index_json, group_num|
        ProtocolAreaGroup.new(client: client, area: area, group_index_json: group_index_json)
      end if @groups.nil?

      @groups
    end

  end

end