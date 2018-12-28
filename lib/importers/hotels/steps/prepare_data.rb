# frozen_string_literal: true

module Importers
  module Hotels
    module Steps
      class PrepareData
        HOTEL_COLUMN_KEYS = %w[
          hotel_id
          destination_id
          address
          latitude
          longitude
          name
          description
          city
          country
          facilities
          amenities
          images
        ].freeze

        attr_reader :json_hash

        def initialize(json_hash)
          raise HotelsError unless json_hash.respond_to?(:keys)

          @json_hash = json_hash.transform_keys(&:downcase)
        end

        def call
          HOTEL_COLUMN_KEYS.each_with_object({}) do |column_key, hash|
            require "./lib/importers/hotels/columns/#{column_key}"
            column_klass = "Importers::Hotels::Columns::#{column_key.camelize}".constantize

            matched_key = column_klass.column_mappings.detect { |column_mapping| json_hash[column_mapping].present? }

            if matched_key
              hash[column_key] = column_klass.new(json_hash[matched_key]).transformed_value
            elsif column_klass.lookup_mappings.present?
              found_lookup = find_in_something(column_key, column_klass)

              hash[column_key] = found_lookup if found_lookup
            end
          end
        end

        private

        def find_in_something(column_key, column_klass)
          column_klass.lookup_mappings.detect do |lookup_mapping|
            found_value_in_lookup = json_hash[lookup_mapping][column_key]
            return column_klass.new(found_value_in_lookup).transformed_value if found_value_in_lookup
          end
        end
      end
    end
  end
end
