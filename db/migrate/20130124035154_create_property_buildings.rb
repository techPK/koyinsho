class CreatePropertyBuildings < ActiveRecord::Migration
  def change
    create_table :property_buildings do |t|
      t.string :bin
      t.string   :borough
      t.string   :block
      t.string   :lot
      t.string   :community_board
      t.string   :street_name
      t.string   :house
      t.string   :zip_code
      t.string   :special_district_1
      t.string   :special_district_2
      t.string   :bldg_type
      t.string   :residential
      t.string   :site_fill
      t.string   :oil_gas     
      t.date :recent_filing_date

      t.timestamps
    end
  end
end
