# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :permit do
    property_borough "MyString"
    property_block_number "MyString"
    property_lot_number "MyString"
  end
end
