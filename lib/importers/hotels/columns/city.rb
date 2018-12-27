# frozen_string_literal: true

require './lib/importers/hotels/columns/base'

module Importers
  module Hotels
    module Columns
      class City < Base
        def self.lookup_mappings
          ['location']
        end

        def transformed_value
          value.strip
        end
      end
    end
  end
end
