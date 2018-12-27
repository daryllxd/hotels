# frozen_string_literal: true

# Hotel columns - This represents a column that is to be inserted in the Hotels table.
#
# self.column_mappings => keys in the json hash that can map to the column name in the Hotels
# table. For example, "name" could be "hotel_name" or "hotelname"
# self.lookup_mappings => in case the value is not located in the root of the hash, these are
# the keys that we can look for the value in. For example, "city" can be found in the root of the
# hash, or in the "location" key like: { "location" => { "city" => "Singapore" } }
#
# transformed_value => given the value in the hash, we transform it (downcasing, trimming, etc.).
# As we cannot make assumptions on the value, we just keep it as it is, and let subclasses override
# it.
module Importers
  module Hotels
    module Columns
      class Base
        attr_reader :value

        def initialize(value)
          @value = value
        end

        def transformed_value
          value
        end

        def self.column_mappings
          [name.demodulize.downcase]
        end

        def self.lookup_mappings
          []
        end
      end
    end
  end
end
