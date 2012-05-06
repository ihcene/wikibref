class InformationVersion < ActiveRecord::Base
  attr_accessible :author, :content, :information, :until
  
  belongs_to :information
end
