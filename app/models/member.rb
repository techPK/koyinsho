class Member < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :username

  def first_name
  	if self.username.nil?
      ''
  	else
  	  self.username.split(',').drop(1).join(',')
  	end
  end

  def first_name=(value)
  	if value
  	  if self.username.nil?
  	    self.username = ',' + value 
  	  else
  	  	self.username = self.username.split(',')[0] + ',' + value
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
  	  self.username.split(',')[0]
  	end
  end

  def last_name=(value)
  	if value
  	  if self.username.nil?
  	    self.username = value + ','
  	  else
  	  	self.username = value + ',' + self.username.split(',').drop(1).join(',')
  	  end
  	else
  	  if self.username
  	  	self.username = self.username.split(',').drop(1) + ','
  	  	self.username = nil if self.username.size == 1
  	  end
  	end
  end

end
