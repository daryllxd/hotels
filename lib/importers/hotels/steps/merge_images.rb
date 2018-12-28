# frozen_string_literal: true

module Importers
  module Hotels
    module Steps
      class MergeImages
        attr_reader :existing_image_hash, :new_image_hash

        def initialize(existing_image_hash, new_image_hash)
          @existing_image_hash = existing_image_hash
          @new_image_hash = new_image_hash
        end

        def call
          return {} unless new_image_hash.respond_to?(:keys)

          { 'images' => new_images_only_hash.merge(existing_images_hash).merge(consolidated_images_hash) }
        end

        private

        def new_images_only_hash
          new_keys = new_image_hash.keys - existing_image_hash.keys
          new_image_hash.slice(*new_keys)
        end

        def existing_images_hash
          existing_keys = existing_image_hash.keys - new_image_hash.keys
          existing_image_hash.slice(*existing_keys)
        end

        def consolidated_images_hash
          intersected_keys = new_image_hash.keys & existing_image_hash.keys

          intersected_keys.each_with_object({}) do |intersected_key, accumulator|
            image_found_in_existing_hash_only = existing_image_hash[intersected_key].reject do |old_image|
              new_image_hash[intersected_key].map { |new_images| new_images['link'] }.include?(old_image['link'])
            end

            accumulator[intersected_key] = image_found_in_existing_hash_only + new_image_hash[intersected_key]
          end
        end
      end
    end
  end
end
