# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :property_building do
    bin {"%07d" % Random.new.rand(4000..9990000)}
    recent_filing_date Date.yesterday
    borough "Staten Island"
    sequence(:block) {|n| ((n % 3) != 0) ? "00701" : "04056" }
    sequence(:lot) {|n| "%05d" % n}
    street_name 'Broadway'
    sequence(:house) {|n| ((n % 3) != 0) ? ("%05d" % Random.new.rand(1..1000)) : ("%05d" % Random.new.rand(55555..99999)) }
    sequence(:community_board) {|n| ((n % 3) != 0) ? "501" : "503" }
    sequence(:zip_code) {|n| ((n % 3) != 0) ? "10301" : "10304" }
  end
end
