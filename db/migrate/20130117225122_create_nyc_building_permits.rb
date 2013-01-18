class CreateNycBuildingPermits < ActiveRecord::Migration
  def change
    create_table :nyc_building_permits do |t|
      t.string :bin_number
      t.string :job_number
      t.string :job_type
      t.string :work_type
      t.string :permit_kind
      t.string :permit_subkind
      t.string :issuance_date
      t.string :expiration_date
      t.string :job_start_date
      t.references :property_building
      t.references :licensed_contractor
      t.references :property_owner

      t.timestamps
    end
    add_index :nyc_building_permits, :property_building_id
    add_index :nyc_building_permits, :licensed_contractor_id
    add_index :nyc_building_permits, :property_owner_id
  end
end
