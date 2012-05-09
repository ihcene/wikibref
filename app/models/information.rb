class Information < ActiveRecord::Base
  attr_accessible :article, :content, :link_for_details, :score, :is_main
  
  belongs_to  :article
  belongs_to  :last_revision_author, :class_name => "Author"
  
  has_many    :versions, :class_name => "InformationVersion"
  
  before_save :create_history, :on => :update
  # before_save :assign_user
  
  self.table_name = "informations"
  
  default_scope where(:deleted => false)
  
  validates :content, :presence => true, :length => { :in => 10..255 }
  
  def destroy
    self.deleted = true
    self.save
  end
  
  private
    def interval_between_versions_passed?
      DateTime.now > (self.updated_at || DateTime.now) + APP_CONFIG['interval_between_versions'].to_i.minutes
    end
  
    def change_by_other_user?
      false
    end
    
    def create_history
      if self.content_changed? && (interval_between_versions_passed? || change_by_other_user?)
        InformationVersion.create(
          :content => self.content_was, 
          :until => DateTime.now, 
          :information => self, 
          :author => last_revision_author
        )
      end
    end
    
    def assign_user
      # self.last_revision_author = article.last_modifier
    end
end
