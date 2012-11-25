class Permit < ActiveRecord::Base
  attr_accessible :property_block_number, :property_borough, :property_lot_number
end
