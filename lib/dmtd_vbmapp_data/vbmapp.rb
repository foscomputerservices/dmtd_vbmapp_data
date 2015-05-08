require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the retrieving of VB-MAPP content from the VB-MAPP Data Server.
  class Vbmapp

    attr_reader :client

    # Creates an accessor for the VB-MAPP content on the VB-MAPP Data Server
    #
    # @note This method does *not* block, simply creates an accessor and returns
    #
    # @option opts [Client] :client A client instance
    def initialize(opts)
      @client = opts.fetch(:client)
    end

    # @note The first call to this method with an expired cache will
    #    block until the cache is populated.  All subsequent calls
    #    will load from the cache.
    #
    # @note The cache is an in-memory cache (not on-disc).  Thus, if the process is restarted,
    #    the cache will be dropped.  Additionally this cache expires once a day at midnight UTC.
    #
    # @return [Array<VbmappArea>] The entire set of {VbmappArea} instances
    def areas
      index_array = index

      @areas = index_array.map do |area_index_json|
        VbmappArea.new(client: client, area_index_json: area_index_json)
      end if @areas.nil? && index_array.is_a?(Array)

      @areas
    end

    private

    def index

      expire_cache
      if defined?(@@vbmapp_index_cache).nil?
        index = retrieve_vbmapp_index
        @@vbmapp_index_cache = {
            date_stamp: DateTime.now.new_offset(0).to_date,
            vbmapp_index: index
        } if index.is_a?(Array) # Only if we got a response

        index
      else
        @@vbmapp_index_cache[:vbmapp_index]
      end
    end

    def expire_cache
      if defined?(@@vbmapp_index_cache)
        today = DateTime.now.new_offset(0).to_date
        cache_day = @@vbmapp_index_cache[:date_stamp]

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