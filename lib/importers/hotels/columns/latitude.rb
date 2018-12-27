# frozen_string_literal: true

require './lib/importers/hotels/columns/base'

module Importers
  module Hotels
    module Columns
      class Latitude < Base
        MAX_LATITUDE = 90
        MIN_LATITUDE = -90

        def transformed_value
          raise HotelsError, 'Invalid latitude' if invalid_latitude?

          value
        end

        private

        # Rescue TypeError for nils
        def invalid_latitude?
          Float(value) > MAX_LATITUDE || Float(value) < MIN_LATITUDE
        rescue TypeError, ArgumentError
          true
        end
      end
    end
  end
end
