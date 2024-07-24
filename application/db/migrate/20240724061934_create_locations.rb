class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations, id: :uuid do |t|
      t.string :ip, null: false
      t.string :url, null: true

      t.string :kind, null: false
      t.string :continent_code, null: false
      t.string :continent_name, null: false
      t.string :country_code, null: false
      t.string :country_name, null: false
      t.string :region_code, null: false
      t.string :region_name, null: false
      t.string :city, null: false
      t.string :zip, null: false
      t.decimal :latitude, null: false, precision: 10, scale: 2
      t.decimal :longitude, null: false, precision: 10, scale: 2

      t.string :location, null: true
      t.string :time_zone, null: true
      t.string :currency, null: true

      t.timestamps
    end

    add_index :locations, :ip
    add_index :locations, :url
    add_index :locations, :latitude
    add_index :locations, :longitude
  end
end
