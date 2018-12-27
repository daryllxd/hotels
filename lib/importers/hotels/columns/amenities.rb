# frozen_string_literal: true

require './lib/importers/hotels/columns/base'
require './lib/importers/hotels/columns/match_finder'

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
          MatchFinder.new(
            potential_values: value,
            possible_values: ALL_AMENITIES,
            hash_key_to_check: 'room',
            error_message: MALFORMED_AMENITY_ERROR
          ).call
        end
      end
    end
  end
end
