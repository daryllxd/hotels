# frozen_string_literal: true

require './lib/importers/hotels/columns/images'

RSpec.describe Importers::Hotels::Columns::Images do
  describe '#transformed_value' do
    describe 'description' do
      it "iterates through each of the images hash's keys and strips the descriptions of whitespace" do
        sample_input = {
          rooms: [
            {
              'link' => 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg',
              'description' => '   Double room     '
            }
          ],
          site: [
            {
              'link' => 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/1.jpg',
              'description' => 'Front     '
            }
          ]
        }

        output = described_class.new(sample_input).transformed_value

        expect(output).to eq(
          rooms: [
            {
              'link' => 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg',
              'description' => 'Double room'
            }
          ],
          site: [
            {
              'link' => 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/1.jpg',
              'description' => 'Front'
            }
          ]
        )
      end

      it 'also looks for a description in the "caption" key' do
        sample_input = {
          rooms: [{ 'link' => 'https://firstimage.com', 'caption' => 'Description' }]
        }

        output = described_class.new(sample_input).transformed_value

        expect(output).to eq(
          rooms: [{ 'link' => 'https://firstimage.com', 'description' => 'Description' }]
        )
      end

      it 'if no keys for "description" or "caption" are found, it returns an empty string' do
        sample_input = {
          rooms: [{ 'link' => 'https://firstimage.com' }]
        }

        output = described_class.new(sample_input).transformed_value

        expect(output).to eq(
          rooms: [{ 'link' => 'https://firstimage.com', 'description' => '' }]
        )
      end
    end

    describe 'link' do
      it 'converts all keys with "url" to "link"' do
        sample_input = {
          rooms: [
            {
              'url' => 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg',
              'caption' => 'Room'
            }
          ]
        }

        output = described_class.new(sample_input).transformed_value

        expect(output).to eq(
          rooms: [
            {
              'link' => 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg',
              'description' => 'Room'
            }
          ]
        )
      end
    end

    it 'raises an error if its not a Hash' do
      expect { described_class.new(nil).transformed_value }
        .to raise_error(HotelsError).with_message('Invalid images, must be a hash')
    end
  end
end
