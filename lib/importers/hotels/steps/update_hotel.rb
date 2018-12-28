# frozen_string_literal: true

require './lib/importers/hotels/steps/merge_images'

module Importers
  module Hotels
    module Steps
      class UpdateHotel
        UPDATEABLE_COLUMNS = %w[destination_id name latitude longitude address city country].freeze
        ADDITIVE_COLUMNS = %w[amenities facilities booking_conditions].freeze

        attr_reader :hotel, :prepared_data

        def initialize(hotel:, prepared_data:)
          @hotel = hotel
          @prepared_data = prepared_data
        end

        def call
          hotel.update_attributes(updated_attributes)
          hotel
        end

        private

        def updated_attributes
          prepared_data
            .slice(*UPDATEABLE_COLUMNS)
            .merge(additive_hash)
            .merge(images_hash)
        end

        # For array-based columns like amenities, facilities, and booking_conditions, we will do a merge with
        # existing amenities/facilities as opposed to a replace.
        def additive_hash
          ADDITIVE_COLUMNS.each_with_object({}) do |column, accumulator|
            if prepared_data[column]
              accumulator[column] = (hotel.public_send(column) + prepared_data[column]).uniq
            end
          end
        end

        def images_hash
          MergeImages.new(hotel.images, prepared_data['images']).call
        end
      end
    end
  end
end
