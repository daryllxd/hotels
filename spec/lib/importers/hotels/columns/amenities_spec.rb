# frozen_string_literal: true

require './lib/importers/hotels/columns/amenities'

RSpec.describe Importers::Hotels::Columns::Amenities do
  describe '#transformed_value' do
    context 'value is given as an array' do
      it 'iterates through the array and matches valid amenities via a Levenshtein match' do
        array_input = [
          'Aircon',
          'Tv',
          'Coffee machine',
          'Kettle',
          'Hair dryer',
          'Iron',
          'Tub'
        ]

        transformed_value = described_class.new(array_input).transformed_value

        expect(transformed_value).to eq(
          [
            'aircon', 'tv', 'coffee machine', 'kettle', 'hair dryer', 'iron', 'bathtub'
          ]
        )
      end

      it 'if unable to find an existing amenity, then do not include the amenity' do
        transformed_value = described_class.new(['invalid amenity']).transformed_value

        expect(transformed_value).to eq([])
      end
    end

    context 'value is given as a hash' do
      it 'looks in the "room" key and finds amenities based on the array inside' do
        hash_input = {
          'room' => ['Aircon', 'Tv', 'Coffee machine', 'Kettle', 'Hair dryer', 'Iron', 'Tub']
        }

        transformed_value = described_class.new(hash_input).transformed_value

        expect(transformed_value).to eq(
          [
            'aircon', 'tv', 'coffee machine', 'kettle', 'hair dryer', 'iron', 'bathtub'
          ]
        )
      end

      it 'if unable to find an existing amenity, then do not include the amenity' do
        transformed_value = described_class.new('room' => ['invalid amenity']).transformed_value

        expect(transformed_value).to eq([])
      end

      context 'no "room" key' do
        it 'raises an error' do
          expect { described_class.new('invalid' => 'hash').transformed_value }
            .to raise_error(HotelsError).with_message('Cannot iterate across the amenities')
        end
      end
    end

    context 'value is not an array or hash' do
      it 'raises an error' do
        expect { described_class.new(nil).transformed_value }
          .to raise_error(HotelsError).with_message('Cannot iterate across the amenities')
      end
    end
  end
end
