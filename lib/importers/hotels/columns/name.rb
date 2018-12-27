# frozen_string_literal: true

require './lib/importers/hotels/columns/base'

module Importers
  module Hotels
    module Columns
      class Name < Base
        def self.column_mappings
          super + %w[hotelname hotel_name]
        end
      end
    end
  end
end
