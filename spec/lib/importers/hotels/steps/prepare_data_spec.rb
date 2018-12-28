# frozen_string_literal: true

require './lib/importers/hotels/steps/prepare_data'

RSpec.describe Importers::Hotels::Steps::PrepareData do
  context 'happy path' do
    it "creates a new hash from the original hash that is cleaned up and maps to the next step's desired input" do
      sample_input = {
        'Id' => 'iJhz',
        'DestinationId' => 5432,
        'Name' => 'Beach Villas Singapore',
        'Latitude' => 1.264751,
        'Longitude' => 103.824006,
        'Address' => ' 8 Sentosa Gateway, Beach Villas ',
        'City' => 'Singapore',
        'Country' => 'SG',
        'PostalCode' => '098269',
        'Description' => '  This 5 star hotel is located on the coastline of Singapore.',
        'Facilities' => ['Pool', 'BusinessCenter', 'WiFi ', 'DryCleaning', ' Breakfast']
      }

      parsed_result = described_class.new(sample_input).call

      expect(parsed_result).to eq(
        'hotel_id' => 'iJhz',
        'destination_id' => 5432,
        'name' => 'Beach Villas Singapore',
        'latitude' => 1.264751,
        'longitude' => 103.824006,
        'address' => '8 Sentosa Gateway, Beach Villas',
        'city' => 'Singapore',
        'country' => 'Singapore',
        'description' => 'This 5 star hotel is located on the coastline of Singapore.',
        'facilities' => ['outdoor pool', 'business center', 'wifi', 'dry cleaning', 'breakfast']
      )
    end

    it 'also checks in the lookup mappings for the column_klass if the key is not found initially' do
      sample_input_with_second_level_data = {
        'hotel_id' => 'iJhz',
        'destination_id' => 5432,
        'location' => {
          'address' => '8 Sentosa Gateway, Beach Villas, 098269',
          'country' => 'SG'
        }
      }

      parsed_result = described_class.new(sample_input_with_second_level_data).call

      expect(parsed_result.keys).to match_array(%w[hotel_id destination_id address country])
    end
  end

  context 'errors' do
    it 'returns an error if not a hash' do
      expect { described_class.new(nil).call }.to raise_error(HotelsError)
    end
  end
end
