# frozen_string_literal: true

require './lib/importers/hotels/columns/destination_id'

RSpec.describe Importers::Hotels::Columns::DestinationId do
  describe '.column_mappings' do
    it 'has destination_id and destinationid' do
      expect(described_class.column_mappings).to match_array(%w[destination_id destinationid])
    end
  end
end
