require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the retrieving of VB-MAPP Guide content from the VB-MAPP Data Server.
  class Guide

    attr_reader :client

    # Creates an accessor for the VB-MAPP Guide on the VB-MAPP Data Server
    #
    # This method does *not* block, simply creates an accessor and returns
    #
    # Params:
    # +client+:: a client instance
    def initialize(opts)
      @client = opts.fetch(:client)
    end

    # Populates the internal VB-MAPP guide index
    #
    # This index is cached locally and expires once a day.
    #
    # The first call to this method with an expired cache will
    # block until the cache is populated.  All subsequent calls
    # will load from the cache.
    #
    # Returns:
    # Array as defined as the result of the 1/guide/index REST api
    def index
      if @guide_index.nil?
        @guide_index = retrieve_guide_index
      end

      @guide_index
    end

    # Returns the VB-MAPP Guide chapters
    #
    # Note that this method calls +index+. See that method for
    # its blocking characteristics.
    def chapters
      index.map.with_index {|chapter_json, chapter_num| GuideChapter.new(client: client, chapter_num: chapter_num, chapter_index_json: chapter_json)}
    end

    private

    def self.end_point
      '1/guide/index'
    end

    def retrieve_guide_index
      response = RequestHelpers::get_authorized(end_point: Guide::end_point, params: nil, client_id: @client.id, client_code: @client.code)
      proc_response = process_response(response)
      json = proc_response[:json]
      server_response_code = proc_response[:code]

      result = json
      result = server_response_code if json.nil?

      result
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