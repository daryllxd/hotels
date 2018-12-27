# frozen_string_literal: true

require './lib/importers/hotels/columns/facilities'

RSpec.describe Importers::Hotels::Columns::Facilities do
  describe '#transformed_value' do
    context 'value is given as an array' do
      it 'iterates through the array and matches valid facilities via a Levenshtein match' do
        array_input = [
          'outdoor pool',
          'business center',
          'childcare',
          'parking',
          'bar',
          'dry cleaning',
          'wifi',
          'breakfast',
          'concierge'
        ]

        transformed_value = described_class.new(array_input).transformed_value

        expect(transformed_value).to eq(
          [
            'outdoor pool',
            'business center',
            'childcare',
            'parking',
            'bar',
            'dry cleaning',
            'wifi',
            'breakfast',
            'concierge'
          ]
        )
      end

      it 'if unable to find an existing facility, then do not include the facility' do
        transformed_value = described_class.new(['invalid facility']).transformed_value

        expect(transformed_value).to eq([])
      end
    end

    context 'value is given as a hash' do
      it 'looks in the "room" key and finds facilities based on the array inside' do
        hash_input = {
          'general' => [
            'outdoor pool', 'business center',
            'childcare', 'parking', 'bar',
            'dry cleaning', 'wifi', 'breakfast', 'concierge'
          ]
        }

        transformed_value = described_class.new(hash_input).transformed_value

        expect(transformed_value).to eq(
          [
            'outdoor pool', 'business center',
            'childcare', 'parking', 'bar',
            'dry cleaning', 'wifi', 'breakfast', 'concierge'
          ]
        )
      end

      it 'if unable to find an existing facility, then do not include the facility' do
        transformed_value = described_class.new('general' => ['invalid facility']).transformed_value

        expect(transformed_value).to eq([])
      end

      context 'no "general" key' do
        it 'raises an error' do
          expect { described_class.new('invalid' => 'hash').transformed_value }
            .to raise_error(HotelsError).with_message('Cannot iterate across the facilities')
        end
      end
    end

    context 'value is not an array or hash' do
      it 'raises an error' do
        expect { described_class.new(nil).transformed_value }
          .to raise_error(HotelsError).with_message('Cannot iterate across the facilities')
      end
    end
  end
end
