require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the retrieving of VB-MAPP Guide content from the VB-MAPP Data Server.
  class Guide

    # @!attribute [r] client
    #   @return [Client] the associated client
    attr_reader :client

    # Creates an accessor for the VB-MAPP Guide on the VB-MAPP Data Server
    #
    # This method does *not* block, simply creates an accessor and returns
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
    # @return [Array<GuideChapter>] The entire set of {GuideChapter} instances
    def chapters
      @chapters = index.map.with_index do |chapter_json, chapter_num|
        GuideChapter.new(client: client, chapter_num: chapter_num, chapter_index_json: chapter_json)
      end if @chapters.nil?

      @chapters
    end

    def expire_cache(opts = {})
      if defined?(@@guide_cache) && !@@guide_cache.nil?
        today = DateTime.now.new_offset(0).to_date
        cache_day = @@guide_cache[:datestamp]

        if cache_day != today || !opts[:force].nil?
          @chapters = nil
          @@guide_cache = nil
        end
      end
    end

    private

    def index
      expire_cache
      unless defined?(@@guide_cache) && !@@guide_cache.nil?
        updated_index = retrieve_guide_index

        if updated_index.is_a?(Array)
          @@guide_cache = {
              datestamp: DateTime.now.new_offset(0).to_date,
              guide_index: updated_index
          }
        else
          @@guide_cache = {
              datestamp: DateTime.now.new_offset(0).to_date - 2.days, # expire immediately
              guide_index: []
          }
        end
      end

      @@guide_cache[:guide_index]
    end

    def self.end_point
      '1/guide/index'
    end

    def retrieve_guide_index
      response = RequestHelpers::get_authorized(end_point: Guide::end_point, params: nil, client_id: @client.id, client_code: @client.code, language: client.language)
      proc_response = RequestHelpers::process_json_response(response)
      json = proc_response[:json]
      server_response_code = proc_response[:code]

      result = json
      result = server_response_code if json.nil?

      result
    end
  end

end