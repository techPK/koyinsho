# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :licensed_contractor do
    licensee_full_name "MyString"
    licensee_business_name "MyString"
    licensee_business_type "MyString"
    licensee_HIC_number "MyString"
    licensee_phone "MyString"
  end
end
