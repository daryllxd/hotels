# frozen_string_literal: true

require './lib/importers/hotels/columns/base'

module Importers
  module Hotels
    module Columns
      class Images < Base
        def transformed_value
          raise HotelsError, 'Invalid images, must be a hash' unless value.is_a?(Hash)

          value.keys.each_with_object({}) do |image_category_key, accumulator|
            accumulator[image_category_key] = value[image_category_key].map do |image|
              cleanup_image(image)
            end
          end
        end

        private

        def cleanup_image(image)
          {
            'link' => image['link'] || image['url'],
            'caption' => image['caption'].strip
          }
        end
      end
    end
  end
end
