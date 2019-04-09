require 'spec_helper'

module DmtdVbmappData

  describe ProtocolAreaQuestion do
    prev_questions = nil

    AVAILABLE_LANGUAGES.each do |language|
      context "Language: #{language}" do
        let(:client) { Client.new(id: VBMDATA_TEST_CLIENT_ID, language: language) }

        it 'can be created' do
          question = ProtocolAreaQuestion.new(client: client, area: 'milestones', group: 'mand', question_json: question_json)
          expect(question).to_not be nil
          expect(question.area).to eq(:milestones)
          expect(question.group).to eq(:mand)
          expect(question.example).to eq(question_json[:example])
          expect(question.materials).to eq(question_json[:materials])
          expect(question.number).to eq(question_json[:number])
          expect(question.text).to eq(question_json[:text])
          expect(question.title).to eq(question_json[:title])
          expect(question.level).to eq(question_json[:level])
        end

        it 'has questions' do
          questions = client.vbmapp.areas[0].groups[0].questions

          expect(questions).to_not be nil
          expect(questions.is_a?(Array)).to be true

          questions.each do |question|
            expect(question.is_a?(DmtdVbmappData::ProtocolAreaQuestion)).to be true

            expect(question.definition).to_not be nil
            expect(question.objective).to_not be nil
            expect(question.number).to_not be nil
            expect(question.text).to_not be nil
            expect(question.title).to_not be nil if question.area == :barriers || question.area == :transitions

            next unless question.area == :milestones

            expect(question.materials).to_not be nil
            expect(question.level).to_not be nil
            expect(question.skills).to_not be nil

            # TODO: VBMASTS-26 -- add support for es/fr
            expect(question.skills.size).to be > 0 if language == 'en'

            question.skills.each do |skill|
              expect(skill.id).to_not be nil
              expect(skill.supporting).to_not be nil
              expect(skill.skill).to_not be nil
            end
          end

          expect(questions).to_not eq(prev_questions) unless prev_questions.nil?

          prev_questions = questions
        end

        it 'has responses' do
          client.vbmapp.areas.each do |area|
            area.groups.each do |group|
              group.questions.each do |question|
                expect(question.is_a?(DmtdVbmappData::ProtocolAreaQuestion)).to be true

                responses = question.responses
                expect(responses).to_not be nil
                expect(responses.is_a?(Array)).to be true

                responses.each do |response|
                  expect(response.area).to eq(area.area)
                  expect(response.score).to_not be nil
                  expect(response.text).to_not be nil
                  expect(response.text.is_a?(String)).to be true
                  expect(response.description).to_not be nil if area.area == :milestones || area.area == :barriers
                  expect(response.description.is_a?(String)).to be true if area.area == :milestones || area.area == :barriers

                  expect(response.score).to be_between(0, 1) if area.area == :milestones || area.area == :eesa
                  expect(response.score).to be >= 0 if area.area == :barriers
                  expect(response.score).to be > 0 if area.area == :transitions
                end
              end
            end
          end
        end

      end
    end

    private

    def question_json
      {
          example: 'example',
          guideContent: {},
          materials: 'wood',
          number: 0,
          text: 'what is this?',
          title: 'a title??',
          questionType: '',
          level: '1',
          responses: []
      }
    end

  end

end
