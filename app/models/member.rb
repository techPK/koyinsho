class UsernameHasFullName < ActiveModel::Validator
  def validate(record)
    if  (record.username.split(',').size < 2) ||
        (record.username.strip.size < 2) ||
        record.username.start_with?(',') 
      record.errors[:base] << "Both First and Last Names must be supplied"
    end 
  end
end

class Member < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :username
  validates_with UsernameHasFullName
  validates_email_format_of :email

  def first_name
  	if self.username.nil?
      ''
  	else
  	  self.username.strip.split(',').drop(1).join(',')
  	end
  end

  def first_name=(value)
  	if value
  	  if self.username.nil?
  	    self.username = ',' + value.strip
  	  else
  	  	self.username = self.username.split(',')[0] + ',' + value.strip
  	  end
  	else
  	  if self.username
  	  	self.username = self.username.split(',')[0] + ','
  	  end
  	end
  end

  def last_name
  	if self.username.nil?
  	  ''
  	else
  	  self.username.split(',')[0].strip
  	end
  end

  def last_name=(value)
  	if value
  	  if self.username.nil?
  	    self.username = value.strip + ','
  	  else
  	  	self.username = value.strip + ', ' + self.username.split(',').drop(1).join(', ')
  	  end
  	else
  	  if self.username
  	  	self.username = self.username.split(',').drop(1) + ','
  	  	self.username = nil if self.username.size == 1
  	  end
  	end
  end

end

