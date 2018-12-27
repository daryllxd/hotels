# frozen_string_literal: true

require 'levenshtein'
require './lib/importers/hotels/columns/base'

module Importers
  module Hotels
    module Columns
      class Amenities < Base
        ALL_AMENITIES = [
          'aircon',
          'minibar',
          'tv',
          'hair dryer',
          'bathtub',
          'coffee machine',
          'kettle',
          'iron',
          ['bathtub', %w[bathtub tub]]
        ].freeze

        MALFORMED_AMENITY_ERROR = 'Cannot iterate across the amenities'

        def transformed_value
          case value
          when Array
            value.map { |amenity| find_amenity_from(amenity) }.compact
          when Hash
            raise HotelsError, MALFORMED_AMENITY_ERROR unless value['room'].present?

            value['room'].map { |amenity| find_amenity_from(amenity) }.compact
          else
            raise HotelsError, MALFORMED_AMENITY_ERROR
          end
        end

        private

        def find_amenity_from(amenity)
          ALL_AMENITIES.detect do |possible_amenity|
            if possible_amenity.is_a?(String)
              Levenshtein.distance(possible_amenity, amenity) < 2
            else
              matched_amenity, amenity_synonyms = possible_amenity

              amenity_synonyms.detect do |amenity_synonym|
                return matched_amenity if Levenshtein.distance(amenity_synonym, amenity) < 2
              end
            end
          end
        end
      end
    end
  end
end
