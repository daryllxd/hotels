# frozen_string_literal: true

require './lib/importers/hotels/columns/latitude'

RSpec.describe Importers::Hotels::Columns::Latitude do
  describe '#transformed_value' do
    it 'if valid, returns the value' do
      expect(described_class.new(1.55).transformed_value).to eq(1.55)
    end

    it 'if invalid, raises an error' do
      expect do
        described_class.new(90.01).transformed_value
      end.to raise_error(HotelsError).with_message('Invalid latitude')

      expect do
        described_class.new(nil).transformed_value
      end.to raise_error(HotelsError).with_message('Invalid latitude')

      expect do
        described_class.new('Hello').transformed_value
      end.to raise_error(HotelsError).with_message('Invalid latitude')
    end
  end
end
