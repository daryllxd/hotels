# frozen_string_literal: true

require './lib/importers/hotels/columns/base'
require './lib/importers/hotels/columns/match_finder'

module Importers
  module Hotels
    module Columns
      class Facilities < Base
        ALL_FACILITIES = [
          ['outdoor pool', %w[pool outdoor_pool]],
          'indoor pool',
          'business center',
          'dry cleaning',
          'breakfast',
          'childcare',
          'parking',
          'bar',
          'wifi',
          'concierge'
        ].freeze

        MALFORMED_FACILITY_ERROR = 'Cannot iterate across the facilities'

        def transformed_value
          MatchFinder.new(
            potential_values: value,
            possible_values: ALL_FACILITIES,
            hash_key_to_check: 'general',
            error_message: MALFORMED_FACILITY_ERROR
          ).call
        end
      end
    end
  end
end
