require 'dmtd_vbmapp_data/request_helpers'

module DmtdVbmappData

  # Provides for the retrieving of VB-MAPP Guide content from the VB-MAPP Data Server.
  class VbmappGuideContent

    # @!attribute [r] definition
    #   @return [String] the formal definition for the question
    attr_reader :definition

    # @!attribute [r] examples
    #   @return [String] An example of how to evaluate the question
    attr_reader :examples

    # @!attribute [r] objective
    #   @return [String] The objective of the question
    attr_reader :objective

    # @!attribute [r] title
    #   @return [String] A title that can be displayed to the user to help identify the question
    attr_reader :title

    # Creates an accessor for the VB-MAPP Guide Content on the VB-MAPP Data Server
    #
    # @note This method does *not* block, simply creates an accessor and returns
    #
    # @option opts [Hash] :guide_content_json The vbmapp question json for the question in the format described at
    #     {https://datamtd.atlassian.net/wiki/pages/viewpage.action?pageId=18710549 /1/vbmapp/area_question - GET REST api - guideContent Fields}
    def initialize(opts)
      guide_content_json = opts.fetch(:guide_content_json)
      @definition = guide_content_json[:definition] || ''
      @examples = guide_content_json[:examples] || ''
      @objective = guide_content_json[:objective] || ''
      @title = guide_content_json[:title] || ''
    end

  end

end