# frozen_string_literal: true

require './lib/importers/hotels/columns/base'

module Importers
  module Hotels
    module Columns
      class Description < Base
        def self.column_mappings
          super + %w[details]
        end

        def transformed_value
          value.strip
        end
      end
    end
  end
end
