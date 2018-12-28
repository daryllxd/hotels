# frozen_string_literal: true

require './lib/importers/hotels/steps/merge_images'

RSpec.describe Importers::Hotels::Steps::MergeImages do
  describe '#call' do
    context 'image hash key is found only in the new_image_hash' do
      it 'adds that hash key to the final hash' do
        existing_image_hash = {}

        new_image_hash = {
          'rooms' => [
            { 'link' => 'google.com/1', caption: 'First room updated' },
            { 'link' => 'google.com/3', caption: 'Third room' }
          ]
        }

        merged_images_hash = described_class.new(existing_image_hash, new_image_hash).call

        expect(merged_images_hash['images']['rooms']).to match_array(
          [
            { 'link' => 'google.com/1', caption: 'First room updated' },
            { 'link' => 'google.com/3', caption: 'Third room' }
          ]
        )
      end
    end

    context 'image hash key is found only in the existing_image_hash' do
      it 'spec_name' do
        existing_image_hash = {
          'rooms' => [{ 'link' => 'google.com/1', caption: 'First room updated' }],
          'amenities' => [{ 'link' => 'google.com/amenities/1', caption: 'First Amenity' }]
        }

        new_image_hash = {}

        merged_images_hash = described_class.new(existing_image_hash, new_image_hash).call

        expect(merged_images_hash['images']['rooms']).to match_array(
          [{ 'link' => 'google.com/1', caption: 'First room updated' }]
        )

        expect(merged_images_hash['images']['amenities']).to match_array(
          [{ 'link' => 'google.com/amenities/1', caption: 'First Amenity' }]
        )
      end
    end

    context 'image hash key found in both existing and new_image_hash' do
      it 'merges the array of images in that hash key, with the new_image_hash taking precedence in case of a conflict' do
        existing_image_hash = {
          'rooms' => [
            { 'link' => 'google.com/1', caption: 'First room' },
            { 'link' => 'google.com/2', caption: 'Second room' }
          ]
        }

        new_image_hash = {
          'rooms' => [
            { 'link' => 'google.com/1', caption: 'First room updated' },
            { 'link' => 'google.com/3', caption: 'Third room' }
          ]
        }

        merged_images_hash = described_class.new(existing_image_hash, new_image_hash).call

        expect(merged_images_hash['images']['rooms']).to match_array(
          [
            { 'link' => 'google.com/1', caption: 'First room updated' },
            { 'link' => 'google.com/2', caption: 'Second room' },
            { 'link' => 'google.com/3', caption: 'Third room' }
          ]
        )
      end
    end

    it 'returns an empty hash if new_image_hash is not actually a hash' do
      no_new_images_hash = described_class.new('irrelevant', nil).call

      expect(no_new_images_hash).to eq({})
    end
  end
end
