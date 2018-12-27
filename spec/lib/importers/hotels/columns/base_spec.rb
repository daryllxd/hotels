# frozen_string_literal: true

require './lib/importers/hotels/columns/base'

RSpec.describe Importers::Hotels::Columns::Base do
  describe '.column_mappings' do
    it 'returns an array' do
      expect(described_class.column_mappings).to eq(['base'])
    end
  end

  describe '.lookup_mappings' do
    it 'returns an empty array, as the default behavior is to lookup only on the base json' do
      expect(described_class.lookup_mappings).to be_empty
    end
  end

  describe '#transformed_value' do
    it 'returns the same value' do
      expect(described_class.new('IRRELEVANT_VALUE').transformed_value).to eq('IRRELEVANT_VALUE')
    end
  end
end
