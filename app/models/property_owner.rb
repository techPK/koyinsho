class PropertyOwner < ActiveRecord::Base
  has_many :property_buildings
  attr_accessible :owner_business_name, :owner_business_type, :owner_city_state
  attr_accessible :owner_full_name, :owner_is_non_profit, :owner_phone
  attr_accessible :owner_recent_filing_date, :owner_street_address
  attr_accessible :owner_zipcode

  def self.search(search_params={})
    # Start ActiveRecord query
    
    case search_params[:sort_by.to_s]
      when "Owner_Name"     then owners_order = "owner_full_name"
      when "Business_Name"     then owners_order = "owner_business_name, owner_full_name"
      when "Business-Type"  then owners_order =
        "owner_business_type, owner_business_name, owner_full_name"
      when "Filing_date" then owners_order = "owner_recent_filing_date"
      else
        owners_order = ''
    end

    property_owners = PropertyOwner.joins(:property_buildings)
 
    search_params.each do |key,value| 
      case key.to_s
        #Property location
        when :borough.to_s then property_owners = property_owners.where(:property_buildings => {borough:value})
        when :block.to_s then property_owners = property_owners.where(:property_buildings => {block:value})
        when :lot.to_s then property_owners = property_owners.where(:property_buildings => {lot:value})
        when :zipcode.to_s then property_owners = property_owners.where(:property_buildings => {zip_code:value})
        when :street.to_s then property_owners = property_owners.where(:property_buildings => ("lower(street_name) = '#{value.downcase}'"))
        when :address_number.to_s then property_owners = property_owners.where(:property_buildings => {house:value})
        when :community_district.to_s then property_owners = property_owners.where(:property_buildings => {community_board:value})
        else
          puts "[PropertyOwner.search] else>>>#{key}:#{value}|<<<"
      end
    end 

    property_owners = property_owners.select("owner_full_name, owner_business_name, phone, owner_business_type, owner_recent_filing_date")  
    property_owners = property_owners.uniq
    property_owners = property_owners.order(owners_order) if owners_order.present?
    
    # Convert property_owners into contractors 
    property_owners		
  end

end
