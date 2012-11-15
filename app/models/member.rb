class Member < ActiveRecord::Base
  attr_accessible :email, :name_full, :visits
end
