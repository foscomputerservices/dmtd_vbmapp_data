require 'spec_helper'

module DmtdVbmappData

  describe VbmappAreaQuestion do

    it 'can be created' do
      question = VbmappAreaQuestion.new(client: client, area: 'milestones', group: 'mand', question_json: question_json)
      expect(question).to_not be nil
      expect(question.area).to eq(:milestones)
      expect(question.group).to eq(:mand)
      expect(question.example).to eq(question_json[:example])
      expect(question.materials).to eq(question_json[:materials])
      expect(question.question_number).to eq(question_json[:questionNumber])
      expect(question.question_text).to eq(question_json[:questionText])
      expect(question.question_title).to eq(question_json[:questionTitle])
    end

    it 'has questions' do
      prev_questions = nil
      AVAILABLE_LANGUAGES.each do |language|
        questions = client(language: language).vbmapp.areas[0].groups[0].questions

        expect(questions).to_not be nil
        expect(questions.is_a?(Array)).to be true

        questions.each do |question|
          expect(question.is_a?(DmtdVbmappData::VbmappAreaQuestion)).to be true

          expect(question.question_number).to_not be nil
          expect(question.question_text).to_not be nil
          expect(question.question_title).to_not be nil if question.area == :barriers || question.area == :transitions
        end

        expect(questions).to_not eq(prev_questions) unless prev_questions.nil?

        prev_questions = questions
      end
    end

    it 'has guide content' do
      client.vbmapp.areas.each do |area|
        area.groups.each do |group|
          group.questions.each do |question|
            if area.area == :eesa
              expect(question.guide_content).to be nil
            else
              expect(question.guide_content).to_not be nil
              expect(question.guide_content.is_a?(VbmappGuideContent)).to be true
            end

          end
        end
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

    private

    def client(opts = {})
      language = opts.fetch(:language, nil)

      Client.new(id: 57, language: language)
    end

    def question_json
      {
          example: 'example',
          guideContent: {},
          materials: 'wood',
          questionNumber: 0,
          questionText: 'what is this?',
          questionTitle: 'a title??',
          questionType: '',
          responses: []
      }
    end

  end

end
