require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the retrieving of VB-MAPP Guide chapter sections from the VB-MAPP Data Server.
  class VbmappAreaGroup

    # @!attribute [r] client
    #   @return [Client] the associated client
    attr_reader :client

    # @!attribute [r] area
    #   @return [Symbol] the area of the question (e.g. :milestones, :barriers, :transitions, :eesa)
    attr_reader :area

    # @!attribute [r] group
    #   @return [Symbol] the group of the question (e.g. :mand, :tact, :group1, etc.)
    attr_reader :group

    # Creates an accessor for the VB-MAPP Area Group on the VB-MAPP Data Server
    #
    # @note This method does *not* block, simply creates an accessor and returns
    #
    # @option opts [Client] :client A client instance
    # @option opts [String | Symbol] :area The vbmapp area of the group (:milestones, :barriers, :transitions', :eesa)
    # @option opts [Hash]   :group_index_json The vbmapp index json for the group in the format described at
    #     {https://datamtd.atlassian.net/wiki/pages/viewpage.action?pageId=18710543 /1/vbmapp/index - GET REST api - Group Fields}
    def initialize(opts)
      @client = opts.fetch(:client)
      @area = opts.fetch(:area).to_sym

      index_json = opts.fetch(:group_index_json)
      @group = index_json[:group].to_sym
      @question_count = index_json[:question_count]
      @levels = index_json[:levels]
    end

    # @note This method *does* block as the content is retrieved
    #
    # @option opts [String | Symbol] :level Filters the questions to the given level (may be null)
    #
    # @return [Array<VbmappAreaQuestion>] all of the area group's {VbmappAreaQuestion} instances
    def questions(opts = {})
      level_name = opts.fetch(:level, nil)

      @questions = retrieve_questions_json.map do |question_json|
        VbmappAreaQuestion.new(client: client, area: area, group: group, question_json: question_json)
      end if @questions.nil?

      if level_name.nil?
        result = @questions
      else
        level_str = level_name.to_s
        level_desc = @levels.select {|level| level[:level].to_s == level_str}[0]
        start_num = level_desc[:start_question_num] + 1 # question_number is 1-based
        end_num = start_num + level_desc[:question_count]

        result = @questions.select {|question| question.question_number >= start_num && question.question_number <= end_num}
      end

      result
    end

    # @note This method does *not* block
    #
    # @return [Symbol] all of the area group's levels
    def levels
      @levels.map {|level_json| level_json[:level].to_sym }
    end

    private

    def self.end_point
      '1/vbmapp/area_question'
    end

    def retrieve_questions_json
      params = {
          area: area,
          group: group
      }
      response = RequestHelpers::get_authorized(end_point: VbmappAreaGroup::end_point, params: params, client_id: @client.id, client_code: @client.code, language: client.language)
      proc_response = RequestHelpers::process_json_response(response)
      json = proc_response[:json]
      server_response_code = proc_response[:code]

      result = json
      result = server_response_code if json.nil?

      result
    end
  end

end