class CreatePropertyOwners < ActiveRecord::Migration
  def change
    create_table :property_owners do |t|
      t.string :owner_full_name
      t.string :owner_business_name
      t.string :owner_business_type
      t.string :owner_street_address
      t.string :owner_city_state
      t.string :owner_zipcode
      t.string :owner_phone
      t.date :owner_recent_filing_date
      t.boolean :owner_is_non_profit

      t.timestamps
    end
  end
end
