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
  attr_accessible :superintendent_first_last_name, :superintendent_business_name, :non_profit, :hic_license

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
 	  property_owner(nyc_permit)
 	  [:owner_s_first_last_name,
		:permittee_s_first_last_name,
		:site_safety_mgr_s_name, 
		:superintendent_first_last_name].each do |name|
		  if nyc_permit[name]
		     nyc_permit[name] = normalized_name(nyc_permit[name])
		   end
	  end
 	  nyc_permit_count += 1 if NycBuildingPermit.create(nyc_permit)	
 	end
  	nyc_permit_count
  end
 
  private

  def self.normalized_name(first_m_last_name)
  	return first_m_last_name unless first_m_last_name.kind_of?(String)
  	
  	return "[#{first_m_last_name}]" if first_m_last_name.include? ' -'
  	return "[#{first_m_last_name}]" if first_m_last_name.include? '- '
  	return "[#{first_m_last_name}]" if first_m_last_name.include? '/'
  	return "[#{first_m_last_name}]" if first_m_last_name.include? ' JR.'
  	return "[#{first_m_last_name}]" if first_m_last_name.include? ' SR.'
  	return "[#{first_m_last_name}]" if first_m_last_name.include? ','
  	return "[#{first_m_last_name}]" if first_m_last_name.include? '+'
  	return "[#{first_m_last_name}]" if first_m_last_name.include? '&'

  	split_names = first_m_last_name.split(' ').map {|w| w.capitalize}
  	return "[#{first_m_last_name}]" if split_names.size <= 1
  	return "[#{first_m_last_name}]" if split_names[-1].include? 'Jr'
  	return "[#{first_m_last_name}]" if split_names[-1].include? 'Sr'
  	last_first_m_name = "#{split_names[-1]}, #{split_names[0..(split_names.size - 2)].join(' ')}"
  end

  def self.property_owner(permit)
  	owner_find = {}
  	owner_update = {}
  	owner_find[:owner_business_name] = permit[:owner_s_business_name]
  	owner_find[:owner_business_type] = permit[:owner_s_business_type]
  	owner_find[:owner_full_name] = normalized_name(permit[:owner_s_first_last_name])
  	owner_find[:owner_street_address] = permit[:owner_s_house_street]
  	city_state_zip = permit[:city_state_zip].split(' ')
  	if (Float(city_state_zip[-1]) != nil rescue false)
  	  owner_find[:owner_zipcode] = city_state_zip.pop
  	  state = city_state_zip.pop 
  	  owner_find[:owner_city_state] = "#{city_state_zip.join(' ')}, #{state}"
  	else
  	  owner_find[:owner_city_state] = "[#{permit[:city_state_zip]}]"
  	end
  	owner_find[:owner_phone] = permit[:owner_s_phone]
  	owner_find[:owner_is_non_profit] = permit[:non_profit].present?
  	owner_update[:owner_recent_filing_date] = Date.parse(permit[:filing_date])
  	property_owner = PropertyOwner.where(owner_find).first_or_create(owner_update)
  	if property_owner[:owner_recent_filing_date] <= owner_update[:owner_recent_filing_date]
  	  property_owner[:owner_recent_filing_date] = owner_update[:owner_recent_filing_date]
  	  property_owner.save
  	end
  	property_owner
  end


end
 