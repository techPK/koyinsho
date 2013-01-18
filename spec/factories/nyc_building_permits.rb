# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :nyc_building_permit do
    bin_number "MyString"
    job_number "MyString"
    job_type "MyString"
    work_type "MyString"
    permit_type "MyString"
    permit_subtype "MyString"
    issuance_date "2013-01-17"
    expiration_date "2013-01-17"
    job_start_date "2013-01-17"
    property_building nil
    licensed_contractor nil
    property_owner nil
  end
end
