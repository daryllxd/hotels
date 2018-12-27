# frozen_string_literal: true

require './lib/importers/hotels/columns/hotel_id'

RSpec.describe Importers::Hotels::Columns::HotelId do
  describe '.column_mappings' do
    it 'has hotel_id, hotelid, and id' do
      expect(described_class.column_mappings).to match_array(%w[hotel_id hotelid id])
    end
  end
end
