class Author < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :username
  
  validates_presence_of :email, :username
  validates_presence_of :password, :on => :create
  
  validates_uniqueness_of :email, :if => :email?
  validates_uniqueness_of :username, :if => :username?
  
  has_secure_password
  
  validates :password, :confirmation => true
end
