require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the retrieving of VB-MAPP area information from the VB-MAPP Data Server.
  class VbmappArea

    attr_reader :client
    attr_reader :area

    # Creates an accessor for the VB-MAPP Guide Chapter on the VB-MAPP Data Server
    #
    # This method does *not* block, simply creates an accessor and returns
    #
    # Params:
    # +client+:: a client instance
    # +area_index_json+:: the vbmapp area index json for the chapter
    def initialize(opts)
      @client = opts.fetch(:client)

      index_json = opts.fetch(:area_index_json)
      @area = index_json[:area]
      @groups_index = index_json[:groups]
    end

    # Returns the VB-MAPP groups
    #
    # This method does *not* block on server access
    def groups
      @groups = @groups_index.map.with_index { |group_index_json, group_num|
        VbmappAreaGroup.new(client: client, area: area, group_index_json: group_index_json)
      } if @groups.nil?

      @groups
    end

    # Returns the possible responses for all questions of this area
    #
    # This method *will* block on the first access to retrieve the
    # data from the server
    def responses
      if @responses.nil?
        responses_json = retrieve_responses_json || []
        @responses = responses_json.map { |response_json| VbmappAreaResponse.new(area: area, response_json: response_json) }
      end

      @responses
    end

    private

    def self.end_point
      '1/vbmapp/area_responses'
    end

    def retrieve_responses_json
      params = {
          area: area
      }
      response = RequestHelpers::get_authorized(end_point: VbmappArea::end_point, params: params, client_id: @client.id, client_code: @client.code, language: client.language)
      proc_response = RequestHelpers::process_json_response(response)
      json = proc_response[:json]
      server_response_code = proc_response[:code]

      result = json
      result = server_response_code if json.nil?

      result
    end

  end

end