require 'spec_helper'

module DmtdVbmappData

  describe AssessmentReport do

    prev_report_json = nil

    AVAILABLE_LANGUAGES.each do |language|
      context "Language: #{language}" do
        let(:client) { Client.new(id: VBMDATA_TEST_CLIENT_ID, language: language) }
        
        it 'can be created' do
          resolver = proc { |var| var}

          expect(AssessmentReport.new(client: client, &resolver)).to_not be nil
        end

        it 'requires a client' do
          resolver = proc { |var| var}

          expect { AssessmentReport.new({}, &resolver) }.to raise_exception
        end

        it 'can generate a report' do
          resolver = proc { |var| 1}
          report_json = client.iep_report(&resolver)

          expect(report_json).to_not be nil
          expect(report_json.is_a?(Array)).to be true

          report_json.each do |para|
            expect(para.is_a?(Hash)).to be true

            expect(para[:Style]).to_not be nil
            expect(para[:Text]).to_not be nil
          end

          expect(report_json).to_not eq(prev_report_json) unless prev_report_json.nil?

          prev_report_json = report_json
        end

      end
    end

  end

end
