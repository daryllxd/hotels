# frozen_string_literal: true

require './lib/importers/hotels/columns/city'

RSpec.describe Importers::Hotels::Columns::City do
  describe '#transformed_value' do
    it 'returns the city without white spaces' do
      expect(described_class.new('  Singapore  ').transformed_value).to eq('Singapore')
    end
  end

  describe '#column_mappings' do
    it 'returns an array with just "city"' do
      expect(described_class.column_mappings).to eq(['city'])
    end
  end

  describe '#lookup_mappings' do
    it 'returns "location"' do
      expect(described_class.lookup_mappings).to match_array(['location'])
    end
  end
end
