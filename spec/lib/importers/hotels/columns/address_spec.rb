# frozen_string_literal: true

require './lib/importers/hotels/columns/address'

RSpec.describe Importers::Hotels::Columns::Address do
  describe '#transformed_value' do
    it 'returns the address without white spaces' do
      expect(described_class.new('  42 Wallaby Way  ').transformed_value).to eq('42 Wallaby Way')
    end
  end

  describe '#lookup_mappings' do
    it 'returns "location"' do
      expect(described_class.lookup_mappings).to match_array(['location'])
    end
  end
end
