# frozen_string_literal: true

require './lib/importers/hotels/importer'

RSpec.describe Importers::Hotels::Importer do
  describe '#call' do
    it 'given a hash, it iterates through the hash and creates a Hotel from that hash' do
      json_file = JSON.parse(File.read('./spec/fixtures/source1.json'))

      described_class.new(json_source: json_file).call

      expect(Hotel.count).to eq(3)
      first_hotel = Hotel.find_by(hotel_id: 'iJhz')

      expected_hotel_hash = {
        destination_id: 5432
      }

      expected_hotel_hash.each do |key, value|
        expect(first_hotel.public_send(key)).to eq(value)
      end
    end

    it 'updates hotels if the same ID is found' do
      json_file = JSON.parse(File.read('./spec/fixtures/source1.json'))
      json_file2 = JSON.parse(File.read('./spec/fixtures/source2.json'))
      json_file3 = JSON.parse(File.read('./spec/fixtures/source3.json'))

      described_class.new(json_source: json_file).call
      described_class.new(json_source: json_file2).call
      described_class.new(json_source: json_file3).call

      expect(Hotel.count).to eq(3)
    end
  end
end
