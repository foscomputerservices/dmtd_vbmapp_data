require 'spec_helper'

module DmtdVbmappData

  describe ProtocolArea do

    AVAILABLE_LANGUAGES.each do |language|
      context "Language: #{language}" do
        let(:client) { Client.new(id: VBMDATA_TEST_CLIENT_ID, language: language) }

        it 'can be created' do
          area = ProtocolArea.new(client: client, area_index_json: area_index_json)
          expect(area).to_not be nil
          expect(area.area).to eq(:milestones)
        end

        it 'has areas' do
          areas = client.vbmapp.areas

          expect(areas).to_not be nil
          expect(areas.is_a?(Array)).to eq(true)
          expect(areas.size).to be > 0

          areas.each do |area|
            expect(area.is_a?(DmtdVbmappData::ProtocolArea)).to eq(true)
          end
        end

      end
    end

    private
    
    def area_index_json
      {
        area: 'milestones',
        groups: []
      }
    end

  end

end
