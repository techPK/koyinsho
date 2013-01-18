class CreateNycBuildingPermits < ActiveRecord::Migration
  def up
    create_table :nyc_building_permits do |t|
      t.string :bin
      
      t.string :job
      t.string :job_type
      t.string :job_doc      
      t.string :work_type
      t.string :permit_sequence
      t.string :permit_type
      t.string :permit_subtype
      t.string :permit_status
      t.string :filing_status      
      t.date :filing_date
      t.date :issuance_date
      t.date :expiration_date
      t.date :job_start_date

      # t.references :property_building
      t.string :borough # =>"BROOKLYN", 
      t.string :block # =>"02099",
      t.string :lot # =>"00006", 
      t.string :community_board # =>"302",
      t.string :street_name # =>"SOUTH ELLIOTT PLACE",
      t.string :house # =>"65",
      t.string :city_state_zip #  =>"BROOKLYN NY 11201", 
      t.string :zip_code #  =>"11217",
      t.string :special_district_1 
      t.string :special_district_2
      t.string :bldg_type # =>"1"
      t.string :residential # =>"YES", 
      t.string :site_fill # =>"USE UNDER 300 CU.YD",
      t.string :oil_gas

      # t.references :licensed_contractor
      t.string :permittee_s_business_name # =>
      t.string :permittee_s_first_last_name # =>"WILLIAM MAURO", 
      t.string :permittee_s_license # =>"0027994", 
      t.string :permittee_s_license_type #  =>"GENERAL CONTRACTOR", 
      t.string :permittee_s_phone # =>"7188582019", 
      t.string :self_cert 
      t.string :hic_license
      
      # t.references :site_safety_manager
      t.string :site_safety_mgr_s_name
      t.string :site_safety_mgr_business_name

      # t.references :superintendent
      t.string :superintendent_first_last_name
      t.string :superintendent_business_name

      # t.references :property_owner
      t.string :owner_s_business_name # =>"BROOKLYN PRESERVATION, LLC"
      t.string :owner_s_business_type # =>"CORPORATION"
      t.string :owner_s_first_last_name # =>"PAUL MURPHY"
      t.string :owner_s_house_street #  =>"135 PACIFIC STREET"  
      t.string :owner_s_phone # =>"7186432777"
      t.string :non_profit
      
      t.timestamps
    end
    # add_index :nyc_building_permits, :property_building_id
    # add_index :nyc_building_permits, :site_safety_manager_id
    # add_index :nyc_building_permits, :superintendent_id
    # add_index :nyc_building_permits, :licensed_contractor_id
    # add_index :nyc_building_permits, :property_owner_id    
  end
  
  def down
    drop_table :nyc_building_permits
  end
end
