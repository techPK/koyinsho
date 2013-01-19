class PropertyOwner < ActiveRecord::Base
  attr_accessible :owner_business_name, :owner_business_type, :owner_city_state, :owner_full_name, :owner_is_non_profit, :owner_phone, :owner_recent_filing_date, :owner_street_address, :owner_zipcode
end
