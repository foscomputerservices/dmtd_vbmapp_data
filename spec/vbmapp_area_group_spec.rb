require 'spec_helper'

module DmtdVbmappData

  describe VbmappAreaGroup do

    it 'can be created' do
      group = VbmappAreaGroup.new(client: client, area: 'milestones', group_index_json: group_index_json)

      expect(group).to_not be nil
      expect(group.area).to eq('milestones')
      expect(group.group).to eq('group1')
    end

    it 'has questions' do
      questions = client.vbmapp.areas[0].groups[0].questions

      expect(questions).to_not be nil

      questions.each do |question|
        expect(question.is_a?(DmtdVbmappData::VbmappAreaQuestion)).to be true
      end
    end

    it 'can filter questions by level' do
      questions = client.vbmapp.areas[0].groups[0].questions(level: 'level3')

      expect(questions).to_not be nil

      questions.each do |question|
        expect(question.is_a?(DmtdVbmappData::VbmappAreaQuestion)).to be true
      end
    end

    private

    def client
      Client.retrieve_clients.first
    end

    def group_index_json
      {
          group: 'group1',
          question_count: 0
      }
    end

  end

end
