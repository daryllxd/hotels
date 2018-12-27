# frozen_string_literal: true

require './lib/importers/hotels/columns/description'

RSpec.describe Importers::Hotels::Columns::Description do
  describe '#transformed_value' do
    it 'returns the description without white spaces' do
      expect(described_class.new(' This is a magical description     ').transformed_value)
        .to eq('This is a magical description')
    end
  end
end
