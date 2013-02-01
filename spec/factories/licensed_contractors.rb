# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :licensed_contractor do
    sequence(:full_name) {|n| ((n % 4) != 0)? "AVATAR, KORRA" : "AVATAR, ANG" }
    sequence(:business_name) {|n| ((n % 4) != 0)? "Water Tribe Group" : "Air Temple" }
    sequence(:license_type) {|n| ((n % 4) != 0)? "MASTER PLUMBER" : "GENERAL CONTRACTOR" }
    sequence(:license_number) {|n| ((n % 4) != 0)? "609087" : "1668" }
    sequence(:his_license_number) {|n| ((n % 8) != 0)? "9876543" : "" }
    sequence(:phone) {|n| ((n % 4) != 0)? "3474464111" : "7183839301" }
    sequence(:self_cert) {|n| ((n % 5) != 0) ? false : true} 
    recent_filing_date Date.yesterday
  end
end
