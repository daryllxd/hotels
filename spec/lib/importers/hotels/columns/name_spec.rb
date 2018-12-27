# frozen_string_literal: true

require './lib/importers/hotels/columns/name'

RSpec.describe Importers::Hotels::Columns::Name do
  describe '.column_mappings' do
    it 'has name, hotel_name, and hotelname' do
      expect(described_class.column_mappings).to match_array(%w[name hotel_name hotelname])
    end
  end
end
