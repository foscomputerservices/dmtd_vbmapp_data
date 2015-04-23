require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the retrieving of VB-MAPP Guide chapter sections from the VB-MAPP Data Server.
  class VbmappAreaGroup

    attr_reader :client
    attr_reader :area
    attr_reader :group

    # Creates an accessor for the VB-MAPP Area Group on the VB-MAPP Data Server
    #
    # This method does *not* block, simply creates an accessor and returns
    #
    # Params:
    # +client+:: a client instance
    # +area+:: the vbmapp area of the group
    # +group_index_json+:: the vbmapp index json for the group
    def initialize(opts)
      @client = opts.fetch(:client)
      @area = opts.fetch(:area)

      index_json = opts.fetch(:group_index_json)
      @group = index_json[:group]
      @question_count = index_json[:question_count]
      @levels = index_json[:levels]
    end

    # Returns the content of the Guide's chapter section
    #
    # This method *does* block as the content is retrieved
    #
    # +level+:: filters the questions to the given level (may be null)
    def questions(opts = {})
      level_name = opts.fetch(:level, nil)

      if @questions.nil?
        question_json = retrieve_question_json

        @questions = question_json.map {|question_json|
          VbmappAreaQuestion.new(client: client, area: area, group: group, question_json: question_json)
        }
      end

      if level_name.nil?
        result = @questions
      else
        level_desc = @levels.select {|level| level[:level] == level_name}[0]
        start_num = level_desc[:start_question_num] + 1 # question_number is 1-based
        end_num = start_num + level_desc[:question_count]

        result = @questions.select {|question| question.question_number >= start_num && question.question_number <= end_num}
      end

      result
    end

    # Returns the VB-MAPP Guide section's sub_sections
    def levels
      @levels = @levels.map { |sub_section_num|
        VbmappAreaLevel.new(client: client, area: area, group: section_num, sub_section_num: sub_section_num)
      } if @levels.nil?

      @levels
    end

    private

    def self.end_point
      '1/vbmapp/area_question'
    end

    def retrieve_question_json
      params = {
          area: area,
          group: group
      }
      response = RequestHelpers::get_authorized(end_point: VbmappAreaGroup::end_point, params: params, client_id: @client.id, client_code: @client.code)
      proc_response = RequestHelpers::process_json_response(response)
      json = proc_response[:json]
      server_response_code = proc_response[:code]

      result = json
      result = server_response_code if json.nil?

      result
    end
  end

end