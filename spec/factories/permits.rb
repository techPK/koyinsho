# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :permit do
    association :property_building
    association :licensed_contractor

    owner_full_name {"#{Faker::Name.last_name}, #{Faker::Name.first_name}"}
    owner_business_name {"#{Faker::Company.name} #{Faker::Company.suffix}"}
    sequence(:owner_business_kind) {|n| ((n % 3) != 0)? "Proprietorship" : 'Corporation'}
    owner_street_address {"#{Faker::Address.building_number} #{Faker::Address.street_name} #{Faker::Address.street_suffix}"}
    owner_city_state {"#{Faker::Address.city}, #{Faker::Address.state_abbr}"}
    owner_zipcode {Faker::Address.zip_code}
    owner_phone {Faker::PhoneNumber.phone_number}

    permit_kind "EW"
    sequence(:permit_subkind) {|n| ((n % 2) != 0)? "OT" : "MH" }
    permit_issuance_date {Date.today} # permit_expiration_date needs to be in a date format

    # sequence(:licensee_full_name) {|n| ((n % 4) != 0)? "MALIK, TARIQ M" : "CALISTO, MICHAEL" }
    # sequence(:licensee_business_name) {|n| ((n % 4) != 0)? "ALLIED REST CORP" : "DMC PLUMBING CORP" }
    # sequence(:licensee_license_kind) {|n| ((n % 4) != 0)? "GENERAL CONTRACTOR" : "MASTER PLUMBER" }
    # sequence(:licensee_license_number) {|n| ((n % 4) != 0)? "609087" : "1668" }
    # licensee_license_HIC_number ""
    # sequence(:licensee_phone) {|n| ((n % 4) != 0)? "(347) 446-4111" : "(718) 383-9301" }

    sequence(:permit_job_number) { |n| "%08d" % Random.new.rand(99999..99999999)}

    owner_is_non_profit false
  end
end


