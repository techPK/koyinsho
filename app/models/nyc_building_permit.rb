class NycBuildingPermit < ActiveRecord::Base
 # belongs_to :property_building
 # belongs_to :licensed_contractor
 # belongs_to :property_owner
 # belongs_to :site_safety_manager
 # belongs_to :superintendent 
  attr_accessible :bin_number, :expiration_date, :issuance_date, :job_number, :job_start_date, :job_type, :permit_subtype, :permit_type, :work_type
  attr_accessible :zip_code, :street_name, :site_fill, :block, :house, :owner_s_first_last_name, :permittee_s_first_last_name, :bldg_type
  attr_accessible :permittee_s_license_type, :filing_status, :owner_s_business_name, :community_board, :owner_s_phone, :special_district_1
  attr_accessible :permit_sequence, :city_state_zip, :job, :borough, :filing_date, :owner_s_house_street, :permit_status, :permittee_s_phone
  attr_accessible :lot, :permittee_s_business_name, :permittee_s_license, :bin, :job_doc, :owner_s_business_type, :site_safety_mgr_business_name
  attr_accessible :special_district_2, :residential, :self_cert, :permit_sequence, :oil_gas, :site_safety_mgr_s_name
  attr_accessible :superintendent_first_last_name, :superintendent_business_name, :non_profit

  def self.nyc_opendata_load(nyc_opendata,record_limit=nil)
  	url = 'http://'
  	url << ENV['NYC_OPEN_DATA_ROOT']
  	url << nyc_opendata
  	url << "?$limit=#{record_limit.to_s.strip}" if record_limit
  	response = Net::HTTP.get_response(URI.parse(url))
  	
  	data = response.body
  	nyc_permits = JSON.parse(data,symbolize_names:true)
 	if nyc_permits.kind_of?(Hash)
 	  return 0 if nyc_permits.has_key? :error
 	end
 	nyc_permit_count = 0
 	nyc_permits.each do |nyc_permit|
 	  nyc_permit_count += 1 if NycBuildingPermit.create(nyc_permit)	
 	end
  	nyc_permit_count
  end
 
end
 