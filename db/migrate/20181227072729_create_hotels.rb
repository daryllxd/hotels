# frozen_string_literal: true

class CreateHotels < ActiveRecord::Migration[5.2]
  def change
    create_table :hotels do |t|
      t.string :hotel_id, null: false
      t.integer :destination_id, null: false
      t.string :name
      t.text :description
      t.float :latitude
      t.float :longitude
      t.string :address
      t.string :city
      t.string :country
      t.string :amenities, array: true, default: []
      t.string :facilities, array: true, default: []
      t.text :booking_conditions, array: true, default: []
      t.jsonb :images, default: {}

      t.timestamps
    end
  end
end
