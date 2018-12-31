# frozen_string_literal: true

require './lib/importers/hotels/steps/prepare_data'
require './lib/importers/hotels/steps/update_hotel'

module Importers
  module Hotels
    class Importer
      attr_reader :json_source

      def initialize(json_source:)
        @json_source = json_source
      end

      def call
        Hotel.transaction do
          json_source.each do |hotel|
            prepared_data = Importers::Hotels::Steps::PrepareData.new(hotel).call

            if (found_hotel = Hotel.find_by(hotel_id: prepared_data['hotel_id']))
              Importers::Hotels::Steps::UpdateHotel.new(
                prepared_data: prepared_data, hotel: found_hotel
              ).call
            else
              Hotel.create!(prepared_data)
            end
          end
        end
      end
    end
  end
end
