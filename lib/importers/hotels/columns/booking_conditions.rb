# frozen_string_literal: true

require './lib/importers/hotels/columns/base'

module Importers
  module Hotels
    module Columns
      class BookingConditions < Base
        def self.column_mappings
          super + %w[booking_conditions]
        end

        def transformed_value
          Array(value).map(&:strip)
        end
      end
    end
  end
end
