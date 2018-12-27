# frozen_string_literal: true

require './lib/importers/hotels/columns/base'

module Importers
  module Hotels
    module Columns
      class DestinationId < Base
        def self.column_mappings
          super + %w[destination_id]
        end
      end
    end
  end
end
