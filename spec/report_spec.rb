require 'spec_helper'

module DmtdVbmappData

  describe AssessmentReport do

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
      report = AssessmentReport.new(client: client, &resolver)

      report_json = report.iep

      expect(report_json).to_not be nil
      expect(report_json.is_a?(Array)).to be true

      report_json.each do |para|
        expect(para.is_a?(Hash)).to be true

        expect(para[:Style]).to_not be nil
        expect(para[:Text]).to_not be nil
      end
    end

    private

    def client
      Client.new(id: 57)
    end
  end

end
