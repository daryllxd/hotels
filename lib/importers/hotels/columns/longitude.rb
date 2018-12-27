# frozen_string_literal: true

require './lib/importers/hotels/columns/base'

module Importers
  module Hotels
    module Columns
      class Longitude < Base
        MAX_LONGITUDE = 180
        MIN_LONGITUDE = -180

        def transformed_value
          raise HotelsError, 'Invalid longitude' if invalid_longitude?

          value
        end

        private

        # Rescue TypeError for nils
        def invalid_longitude?
          Float(value) > MAX_LONGITUDE || Float(value) < MIN_LONGITUDE
        rescue TypeError, ArgumentError
          true
        end
      end
    end
  end
end
