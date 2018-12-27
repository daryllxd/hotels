# frozen_string_literal: true

require './lib/importers/hotels/columns/booking_conditions'

RSpec.describe Importers::Hotels::Columns::BookingConditions do
  describe '.column_mappings' do
    it 'has "bookingconditions" and "booking_conditions"' do
      expect(described_class.column_mappings).to match_array(%w[bookingconditions booking_conditions])
    end
  end

  describe '#transformed_value' do
    it 'turns strings into arrays' do
      expect(described_class.new('This is a magical booking condition').transformed_value)
        .to eq(['This is a magical booking condition'])
    end

    it 'if an array was passed in, it strips each condition' do
      conditions = [
        '    All children are welcome. ',
        '     Pets are not allowed.     '
      ]
      expect(described_class.new(conditions).transformed_value)
        .to match_array(
          [
            'All children are welcome.',
            'Pets are not allowed.'
          ]
        )
    end
  end
end
