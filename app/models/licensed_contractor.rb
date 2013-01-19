class LicensedContractor < ActiveRecord::Base
  attr_accessible :licensee_HIC_number, :licensee_business_name, :licensee_business_type, :licensee_full_name, :licensee_phone
  attr_accessible :licensee_recent_filing_date, :licensee_number
end
