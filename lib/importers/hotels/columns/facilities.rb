# frozen_string_literal: true

require 'levenshtein'
require './lib/importers/hotels/columns/base'

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
          case value
          when Array
            value.map { |facility| find_facility_from(facility) }.compact
          when Hash
            raise HotelsError, MALFORMED_FACILITY_ERROR unless value['general'].present?

            value['general'].map { |facility| find_facility_from(facility) }.compact
          else
            raise HotelsError, MALFORMED_FACILITY_ERROR
          end
        end

        private

        def find_facility_from(facility)
          ALL_FACILITIES.detect do |possible_facility|
            if possible_facility.is_a?(String)
              Levenshtein.distance(possible_facility, facility) < 2
            else
              matched_facility, facility_synonyms = possible_facility

              facility_synonyms.detect do |facility_synonym|
                return matched_facility if Levenshtein.distance(facility_synonym, facility) < 2
              end
            end
          end
        end
      end
    end
  end
end
