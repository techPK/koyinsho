class LicensedContractor < ActiveRecord::Base
  has_many :permits
  attr_accessible :hic_number, :business_name, :license_type
  attr_accessible :full_name, :phone, :self_certified
  attr_accessible :recent_filing_date, :license_number, :bin

  def self.search(search_params={})
    # Start ActiveRecord query

    licensed_contractors = LicensedContractor.scoped

    search_params.each do |key,value| 
      case key
        #Property location
        when :borough.to_s then licensed_contractors = licensed_contractors.joins(:permits =>:property_building).where(:property_buildings => {borough:value})
        when :block.to_s then licensed_contractors = licensed_contractors.joins(:permits =>:property_building).where(:property_buildings => {block:value})
        when :lot.to_s then licensed_contractors = licensed_contractors.joins(:permits =>:property_building).where(:property_buildings => {lot:value})
        when :zipcode.to_s then licensed_contractors = licensed_contractors.joins(:permits =>:property_building).where(:property_buildings => {zip_code:value})
        when :street.to_s then licensed_contractors = licensed_contractors.joins(:permits =>:property_building).where(:property_buildings => ("lower(street_name) = '#{value.downcase}'"))
        when :address_number.to_s then licensed_contractors = licensed_contractors.joins(:permits =>:property_building).where(:property_buildings => {house:value})
        when :community_district.to_s then licensed_contractors = licensed_contractors.joins(:permits =>:property_building).where(:property_buildings => {community_board:value})
        #Other
        when :license_type.to_s then licensed_contractors = licensed_contractors.where(license_type:value)
        when :permit_type.to_s
          licensed_contractors = licensed_contractors.joins(:permits).where(permit_kind:value[0,2])
          licensed_contractors = licensed_contractors.joins(:permits).where(permit_subkind:value[3,2]) if value.size > 2
        else
          puts "[LicensedContractor.search_for_contractors] else>>>#{key}:#{value}|<<<"
      end
    end 
    # Convert licensed_contractors into contractors 
    licensed_contractors		
  end

end
