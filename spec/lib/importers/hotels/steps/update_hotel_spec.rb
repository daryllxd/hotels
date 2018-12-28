# frozen_string_literal: true

require './lib/importers/hotels/steps/update_hotel'
require './lib/importers/hotels/steps/merge_images'

RSpec.describe Importers::Hotels::Steps::UpdateHotel do
  context 'happy path' do
    it 'updates the attributes for the updateable columns' do
      hotel = Hotel.create(
        'hotel_id' => 'iJhz',
        'destination_id' => 5432,
        'name' => 'Beach Villas Singapore',
        'latitude' => 1.264751,
        'longitude' => 103.824006,
        'address' => '8 Sentosa Gateway, Beach Villas',
        'city' => 'Singapore',
        'country' => 'Singapore',
        'description' => 'This 5 star hotel is located on the coastline of Singapore.'
      )

      sample_input = {
        'hotel_id' => 'iJhz',
        'destination_id' => 1234,
        'name' => 'Other Hotel',
        'latitude' => 9.99,
        'longitude' => 9.99,
        'address' => 'Other address',
        'city' => 'Tokyo',
        'country' => 'Japan',
        'description' => 'Newer description'
      }

      updated_hotel = described_class.new(
        hotel: hotel,
        prepared_data: sample_input
      ).call

      sample_input.keys do |key, expected_value|
        expect(updated_hotel.public_send(key.to_sym)).to eq(expected_value)
      end
    end

    it 'amenities, facilities, and booking_conditions are merged' do
      hotel = Hotel.create(
        'hotel_id' => 'iJhz',
        'destination_id' => 5432,
        'amenities' => ['aircon', 'tv', 'coffee machine'],
        'facilities' => ['outdoor pool', 'business center', 'wifi'],
        'booking_conditions' => ['Pets are allowed.']
      )

      sample_input = {
        'hotel_id' => 'iJhz',
        'amenities' => ['aircon', 'kettle', 'hair dryer'],
        'facilities' => ['outdoor pool', 'indoor pool', 'childcare'],
        'booking_conditions' => ['Must pay with card.']
      }

      updated_hotel = described_class.new(
        hotel: hotel,
        prepared_data: sample_input
      ).call

      expect(updated_hotel.amenities).to match_array(['aircon', 'tv', 'coffee machine', 'kettle', 'hair dryer'])
      expect(updated_hotel.facilities).to match_array(['outdoor pool', 'business center', 'wifi', 'indoor pool', 'childcare'])
      expect(updated_hotel.booking_conditions).to match_array(['Pets are allowed.', 'Must pay with card.'])
    end

    it 'a call is made to MergeImages to merge the images' do
      hotel = Hotel.create(
        'hotel_id' => 'iJhz',
        'destination_id' => 5432
      )

      sample_input = {
        'hotel_id' => 'iJhz',
        'destination_id' => 5432,
        'images' => {}
      }

      expect_any_instance_of(Importers::Hotels::Steps::MergeImages).to receive(:call).and_return({})
      described_class.new(hotel: hotel, prepared_data: sample_input).call
    end
  end
end
