# frozen_string_literal: true

require './lib/importers/hotels/columns/description'

RSpec.describe Importers::Hotels::Columns::Description do
  describe '.column_mappings' do
    it 'has "details" and "description"' do
      expect(described_class.column_mappings).to match_array(%w[details description])
    end
  end

  describe '#transformed_value' do
    it 'returns the description without white spaces' do
      expect(described_class.new(' This is a magical description     ').transformed_value)
        .to eq('This is a magical description')
    end
  end
end
