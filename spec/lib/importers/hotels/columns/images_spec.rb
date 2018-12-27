# frozen_string_literal: true

require './lib/importers/hotels/columns/images'

RSpec.describe Importers::Hotels::Columns::Images do
  describe '#transformed_value' do
    it 'strips the descriptions of whitespace' do
      sample_input = {
        rooms: [
          {
            'link' => 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg',
            'caption' => '   Double room     '
          }
        ],
        site: [
          {
            'link' => 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/1.jpg',
            'caption' => 'Front     '
          }
        ]
      }

      output = described_class.new(sample_input).transformed_value

      expect(output).to eq(
        rooms: [
          {
            'link' => 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg',
            'caption' => 'Double room'
          }
        ],
        site: [
          {
            'link' => 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/1.jpg',
            'caption' => 'Front'
          }
        ]
      )
    end

    it 'raises an error if its not a Hash' do
      expect { described_class.new(nil).transformed_value }
        .to raise_error(HotelsError).with_message('Invalid images, must be a hash')
    end
  end
end
