class Information < ActiveRecord::Base
  attr_accessible :article, :content, :is_main, :last_revision_author, :score
end
