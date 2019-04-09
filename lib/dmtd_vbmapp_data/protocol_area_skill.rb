require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the retrieving of VB-MAPP Area Question Skill on the VB-MAPP Data Server.
  class ProtocolAreaSkill

    # @!attribute [r] id
    #   @return [Symbol] the Skill Id
    attr_reader :id

    # @!attribute [r] supporting
    #   @return [Bool] whether the skill is a supporting skill
    attr_reader :supporting

    # @!attribute [r] skill
    #   @return [String] the description of the skill
    attr_reader :skill

    # Creates an accessor for the VB-MAPP Area Question Skill on the VB-MAPP Data Server
    #
    # @note This method does *not* block, simply creates an accessor and returns
    #
    # @option opts [Hash]   :question_json The vbmapp question json for the question in the format described at
    #     {https://datamtd.atlassian.net/wiki/pages/viewpage.action?pageId=18710549 /1/protocol/area_question - GET REST api - Fields}
    def initialize(opts)
      question_json = opts.fetch(:question_json)

      @id = question_json[:id]
      @supporting = question_json[:supporting]
      @skill = question_json[:skill]
    end

  end

end