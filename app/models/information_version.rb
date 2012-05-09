class InformationVersion < ActiveRecord::Base
  attr_accessible :author, :content, :information, :until
  
  belongs_to :information
  belongs_to :author
end
