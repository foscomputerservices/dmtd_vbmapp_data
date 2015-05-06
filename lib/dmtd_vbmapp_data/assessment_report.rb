require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the tailoring of a VB-MAPP report from the VB-MAPP Data Server.
  #
  # This class retrieves the report for the given client and performs the following operations on the report data
  # before returning the final JSON:
  #
  # * All variables are substituted
  # * All conditional statements are executed and only the sections that apply are returned
  #
  # The only step remaining is to format the resulting JSON into whatever output format is required (e.g. RTF, PDF, HTML, etc.).
  class AssessmentReport

    # Resolver is a block that takes a single argument, a string, which is the variable name.  The result
    # should be the value to bind to that variable.
    attr_reader :resolver

    # The client for which the report will be generated
    attr_reader :client

    # The language in which the report will be generated
    attr_reader :language

    # Initializes the receiver with the given options:
    #
    # This method does *not* block, simply creates an accessor and returns
    #
    # Params:
    # +client+:: The client for which to run the report
    # +resolver+:: See +resolver+ above
    # +language+:: the language to use (i.e. 'en', 'es' or may be nil)
    def initialize(opts, &resolver)
      @client = opts.fetch(:client)
      @resolver = resolver
      @language = opts.fetch(:language, nil)
    end

    # Returns the JSON for the IEP report (see https://datamtd.atlassian.net/wiki/pages/viewpage.action?pageId=19267590) for the
    # full format.
    #
    # The following transformations are made to the server JSON:
    #
    # * The top-level 'response' node is removed
    # * All variables are substituted according to +resolver+
    # * All conditionals are evaluated
    #    * Only paragraphs with successful conditions are retained
    #    * All Condition nodes are stripped
    #    * All Condition_Comment nodes are stripped
    #
    # This method *will* block on the first access to retrieve the
    # data from the server.
    #
    # Note that the keys in the JSON hash will be symbols and *not* strings.
    def iep
      result = retrieve_responses_json

      if result.is_a?(Array)
        result = process_report json_array:result
      end

      result
    end

    private

    def process_report(json_array:)
      filtered_json = json_array.select do |para|
        keep_para = true
        condition = para[:Condition]

        unless condition.nil?
          keep_para = eval(sub_vars(condition))
        end

        keep_para
      end

      filtered_json.map do |para|
        {
          Style: para[:Style],
          Text: sub_vars(para[:Text])
        }
      end
    end

    def sub_vars(sub_string)
      result = sub_string

      sub_string.scan(/%([a-zA-Z_][a-zA-Z0-9_]*)%/).flatten.each do |var|
        result = result.gsub("%#{var}%", resolver.call(var).to_s)
      end

      result
    end

    def self.end_point
      '1/assessment_report/iep'
    end

    def retrieve_responses_json
      response = RequestHelpers::get_authorized(end_point: AssessmentReport::end_point, params: nil, client_id: @client.id, client_code: @client.code, language: language)
      proc_response = RequestHelpers::process_json_response(response)
      json = proc_response[:json]
      server_response_code = proc_response[:code]

      result = json
      result = server_response_code if json.nil?

      result
    end

  end

end
