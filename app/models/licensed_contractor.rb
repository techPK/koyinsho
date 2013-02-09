class LicensedContractor < ActiveRecord::Base
  has_many :permits
  has_many :property_buildings, :through => :permits 
  attr_accessible :hic_number, :business_name, :license_type
  attr_accessible :full_name, :phone, :self_certified
  attr_accessible :recent_filing_date, :license_number, :bin

  def self.search(search_params={})
    # Start ActiveRecord query
    
    case search_params[:sort_by.to_s]
      when "Licensee"     then permits_order =
        "full_name, license_type"
      when "License-Type"  then permits_order =
        "license_type, business_name, full_name"
      when "Business-Name" then permits_order =
        "business_name, license_type, full_name"
      else
        permits_order = ''
    end

    licensed_contractors = LicensedContractor.joins(:permits, :property_buildings)
 
    search_params.each do |key,value| 
      case key.to_s
        #Property location
        when :borough.to_s then licensed_contractors = licensed_contractors.where(:property_buildings => {borough:value})
        when :block.to_s then licensed_contractors = licensed_contractors.where(:property_buildings => {block:value})
        when :lot.to_s then licensed_contractors = licensed_contractors.where(:property_buildings => {lot:value})
        when :zipcode.to_s then licensed_contractors = licensed_contractors.where(:property_buildings => {zip_code:value})
        when :street.to_s then licensed_contractors = licensed_contractors.where(:property_buildings => ("lower(street_name) = '#{value.downcase}'"))
        when :address_number.to_s then licensed_contractors = licensed_contractors.where(:property_buildings => {house:value})
        when :community_district.to_s then licensed_contractors = licensed_contractors.where(:property_buildings => {community_board:value})
        #Other
        when :license_type.to_s then licensed_contractors = licensed_contractors.where(license_type:value)
        when :work_type.to_s
          licensed_contractors = licensed_contractors.where(:permits => {permit_kind:value[0,2]})
          licensed_contractors = licensed_contractors.where(:permits => {permit_subkind:value[3,2]}) if value.size > 2
        else
          puts "[LicensedContractor.search] else>>>#{key}:#{value}|<<<"
      end
    end 

    licensed_contractors = licensed_contractors.select("full_name, business_name, phone, license_type, license_number")  
    licensed_contractors = licensed_contractors.uniq
    licensed_contractors = licensed_contractors.order(permits_order) if permits_order.present?
    
    # Convert licensed_contractors into contractors 
    licensed_contractors		
  end

end
