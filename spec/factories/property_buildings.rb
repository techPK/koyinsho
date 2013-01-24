# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :property_building do
    bin "MyString"
    recent_filing_date "2013-01-23"
  end
end
