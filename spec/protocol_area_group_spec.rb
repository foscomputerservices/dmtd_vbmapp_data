require 'spec_helper'

module DmtdVbmappData

  prev_questions = nil

  describe ProtocolAreaGroup do

    AVAILABLE_LANGUAGES.each do |language|

      context "Language: #{language}" do
        let(:client) { Client.new(id: VBMDATA_TEST_CLIENT_ID, language: language) }

        it 'can be created' do
          group = ProtocolAreaGroup.new(client: client, area: 'milestones', group_index_json: group_index_json)

          expect(group).to_not be nil
          expect(group.area).to eq(:milestones)
          expect(group.group).to eq(:group)
        end

        it 'has questions' do
          questions = client.vbmapp.areas[0].groups[0].questions

          expect(questions).to_not be nil

          questions.each do |question|
            expect(question.is_a?(DmtdVbmappData::ProtocolAreaQuestion)).to be true
          end

          expect(questions).to_not eq(prev_questions) unless prev_questions.nil?

          prev_questions = questions
        end

        it 'can filter questions by level' do
          group = client.vbmapp.areas[0].groups[0]

          if group.area == :milestones
            expect(group.levels.size).to eq(3)
          else
            expect(group.levels.size).to eq(0)
          end

          group.levels.each do |level|
            questions = group.questions(level: level)

            expect(questions).to_not be nil

            questions.each do |question|
              expect(question.is_a?(DmtdVbmappData::ProtocolAreaQuestion)).to be true
            end
          end
        end

      end
    end
    
    private

    def group_index_json
      {
          group: 'group',
          question_count: 0
      }
    end

  end

end
