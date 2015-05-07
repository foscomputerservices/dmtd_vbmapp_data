require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the retrieving of VB-MAPP content from the VB-MAPP Data Server.
  class Vbmapp

    attr_reader :client

    # Creates an accessor for the VB-MAPP content on the VB-MAPP Data Server
    #
    # This method does *not* block, simply creates an accessor and returns
    #
    # Params:
    # +client+:: a client instance
    def initialize(opts)
      @client = opts.fetch(:client)
    end

    # Populates the internal VB-MAPP content index
    #
    # This index is cached locally and expires once a day at midnight UTC.
    #
    # The first call to this method with an expired cache will
    # block until the cache is populated.  All subsequent calls
    # will load from the cache.
    #
    # NOTE: The cache is an in-memory cache (not on-disc).  Thus, if the process is restarted,
    #       the cache will be dropped.
    #
    # Returns:
    # Array as defined as the result of the 1/guide/index REST api
    def index

      expire_cache
      if defined?(@@vbmapp_index_cache).nil?
        @@vbmapp_index_cache = {
            datestamp: DateTime.now.new_offset(0).to_date,
            vbmapp_index: retrieve_vbmapp_index
        }
      end

      @@vbmapp_index_cache[:vbmapp_index]
    end

    # Returns the VB-MAPP Areas
    #
    # Note that this method calls +index+. See that method for
    # its blocking characteristics.
    def areas
      @areas = index.map {|area_index_json| VbmappArea.new(client: client, area_index_json: area_index_json)} if @areas.nil?

      @areas
    end

    private

    def expire_cache
      if defined?(@@vbmapp_index_cache)
        today = DateTime.now.new_offset(0).to_date
        cache_day = @@vbmapp_index_cache[:datestamp]

        @@vbmapp_index_cache = nil unless cache_day == today
      end
    end

    def self.end_point
      '1/vbmapp/index'
    end

    def retrieve_vbmapp_index
      response = RequestHelpers::get_authorized(end_point: Vbmapp::end_point, params: nil, client_id: @client.id, client_code: @client.code, languge: client.language)
      proc_response = RequestHelpers::process_json_response(response)
      json = proc_response[:json]
      server_response_code = proc_response[:code]

      result = json
      result = server_response_code if json.nil?

      result
    end

  end

end