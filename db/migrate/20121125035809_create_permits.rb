class CreatePermits < ActiveRecord::Migration
  def change
    create_table :permits do |t|
      t.string :property_borough
      t.string :property_block_number
      t.string :property_lot_number
      t.string :property_community_district_number
      t.string :property_address_number
      t.string :property_street
      t.string :property_zipcode
      t.string :owner_full_name
      t.string :owner_business_name
      t.string :owner_business_kind 
   	  t.string :owner_street_address
	  t.string :owner_city_state
      t.string :owner_zipcode
      t.string :owner_phone      
      t.string :permit_kind
      t.string :permit_subkind
      t.string :permit_expiration_date
      t.string :licensee_full_name
      t.string :licensee_business_name
      t.string :licensee_license_kind
      t.string :licensee_license_number
      t.string :licensee_license_HIC_number
      t.string :licensee_other_title
      t.string :licensee_phone      

      t.timestamps
    end
  end
end
