# frozen_string_literal: true

require './lib/importers/hotels/columns/base'

module Importers
  module Hotels
    module Columns
      class Country < Base
        def self.lookup_mappings
          ['location']
        end

        ABBREVIATION_LOOKUP = {
          'Singapore' => 'SG',
          'Japan' => 'JP'
        }.freeze

        attr_reader :value

        def initialize(value)
          @value = value.strip
        end

        def transformed_value
          return value if ABBREVIATION_LOOKUP.key?(value)
          return ABBREVIATION_LOOKUP.key(value) if ABBREVIATION_LOOKUP.key(value)

          raise HotelsError, "Invalid country name for #{value}"
        end
      end
    end
  end
end
