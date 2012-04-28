class Author < ActiveRecord::Base
  attr_accessible :email, :password, :password_salt, :username
end
