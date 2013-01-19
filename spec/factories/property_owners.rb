# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :property_owner do
    owner_full_name "MyString"
    owner_business_name "MyString"
    owner_business_type "MyString"
    owner_street_address "MyString"
    owner_city_state "MyString"
    owner_zipcode "MyString"
    owner_phone "MyString"
    owner_recent_filing_date "2013-01-18"
    owner_is_non_profit false
  end
end
