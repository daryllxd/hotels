# frozen_string_literal: true

require './lib/importers/hotels/columns/country'

RSpec.describe Importers::Hotels::Columns::Country do
  describe '#transformed_value' do
    it 'if abbreviation, return the correct country' do
      expect(described_class.new('SG').transformed_value).to eq('Singapore')
    end

    it 'if country name, return the actual country name' do
      expect(described_class.new('Singapore').transformed_value).to eq('Singapore')
    end
  end

  describe '#column_mappings' do
    it 'returns an array' do
      expect(described_class.column_mappings).to eq(['country'])
    end
  end

  describe '#lookup_mappings' do
    it 'returns "location"' do
      expect(described_class.lookup_mappings).to match_array(['location'])
    end
  end
end
