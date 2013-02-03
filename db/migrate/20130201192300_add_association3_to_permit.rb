class AddAssociation3ToPermit < ActiveRecord::Migration
  def up
    add_column :permits, :licensed_contractor_id, :integer
    
    remove_column :permits, :property_borough
    remove_column :permits, :property_block_number
    remove_column :permits, :property_lot_number
    remove_column :permits, :property_community_district_number
    remove_column :permits, :property_address_number
    remove_column :permits, :property_street
    remove_column :permits, :property_zipcode

    remove_column :permits, :licensee_full_name
    remove_column :permits, :licensee_business_name
    remove_column :permits, :licensee_license_kind
    remove_column :permits, :licensee_license_number
    remove_column :permits, :licensee_license_HIC_number
    remove_column :permits, :licensee_phone
  end
  
  def down
    remove_column :permits, :licensed_contractor_id
    
    add_column :permits, :property_borough, :string
    add_column :permits, :property_block_number, :string
    add_column :permits, :property_lot_number, :string
    add_column :permits, :property_community_district_number, :string
    add_column :permits, :property_address_number, :string
    add_column :permits, :property_street, :string
    add_column :permits, :property_zipcode, :string

    add_column :permits, :licensee_full_name, :string
    add_column :permits, :licensee_business_name, :string
    add_column :permits, :licensee_license_kind, :string
    add_column :permits, :licensee_license_number, :string
    add_column :permits, :licensee_license_HIC_number, :string
    add_column :permits, :licensee_phone, :string
  end
end
