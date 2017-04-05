require 'spec_helper'

module DmtdVbmappData

  describe Protocol do

    AVAILABLE_LANGUAGES.each do |language|
      context "Language: #{language}" do

        it 'can be created' do
          client = Client.new(date_of_birth: Date.today, gender: DmtdVbmappData::GENDER_FEMALE, language: language)

          expect(Protocol.new(client: client)).to_not be nil
        end

        it 'can provide areas' do
          vbmapp = Protocol.new(client: Client.new(date_of_birth: Date.today, gender: DmtdVbmappData::GENDER_FEMALE, language: language))

          expect(vbmapp.areas).to_not be nil
          expect(vbmapp.areas.is_a?(Array)).to eq(true)
          vbmapp.areas.each do |chapter|
            expect(chapter.is_a?(DmtdVbmappData::ProtocolArea)).to eq(true)
          end
        end

      end
    end

  end

end