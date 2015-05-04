require 'spec_helper'

module DmtdVbmappData

  describe VbmappAreaQuestion do

    it 'can be created' do
      question = VbmappAreaQuestion.new(client: client, area: 'milestones', group: 'mand', question_json: question_json)
      expect(question).to_not be nil
      expect(question.area).to eq('milestones')
      expect(question.group).to eq('mand')
      expect(question.example).to eq(question_json[:example])
      expect(question.materials).to eq(question_json[:materials])
      expect(question.question_number).to eq(question_json[:questionNumber])
      expect(question.question_text).to eq(question_json[:questionText])
    end

    it 'has questions' do
      questions = client.vbmapp.areas[0].groups[0].questions

      expect(questions).to_not be nil
      expect(questions.is_a?(Array)).to be true

      questions.each do |question|
        expect(question.is_a?(DmtdVbmappData::VbmappAreaQuestion)).to be true
      end
    end

    it 'has responses' do
      client.vbmapp.areas.each do |area|
        area.groups.each do |group|
          group.questions.each do |question|
            expect(question.is_a?(DmtdVbmappData::VbmappAreaQuestion)).to be true

            responses = question.responses
            expect(responses).to_not be nil
            expect(responses.is_a?(Array)).to be true

            responses.each do |response|
              expect(response.area).to eq(area.area)
              expect(response.score).to_not be nil
              expect(response.text).to_not be nil
              expect(response.text.is_a?(String)).to be true
              expect(response.description).to_not be nil if area.area.to_sym == :milestones || area.area.to_sym == :barriers
              expect(response.description.is_a?(String)).to be true if area.area.to_sym == :milestones || area.area.to_sym == :barriers
            end
          end
        end
      end
    end

    private

    def client
      Client.retrieve_clients.first
    end

    def question_json
      {
          example: 'example',
          guideContent: {},
          materials: 'wood',
          questionNumber: 0,
          questionText: 'what is this?',
          questionType: '',
          responses: []
      }
    end

  end

end
