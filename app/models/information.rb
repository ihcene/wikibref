class Information < ActiveRecord::Base
  attr_accessible :article, :content, :link_for_details, :score, :is_main
  
  belongs_to  :article
  belongs_to  :last_revision_author, :class_name => "Author"
  
  has_many    :versions, :class_name => "InformationVersion", :order => "created_at DESC"
  
  before_save :create_history, :on => :update
  
  self.table_name = "informations"
  
  default_scope where(:deleted => false)
  
  validates :content, :presence => true, :length => { :in => APP_CONFIG['informations']['min_length']..APP_CONFIG['informations']['max_length'] }
  
  def destroy
    self.deleted = true
    self.save
  end
  
  def history
    updates = []
    
    if versions.any?
      updates << {
        :type           => :info_updated,
        :content_from   => self.versions.first.content,
        :content_to     => self.content,
        :date           => self.updated_at,
        :author         => self.last_revision_author 
      }
      
      self.versions.each_with_index do |version, i|
        if i == self.versions.count - 1
          updates << {
            :type           => :info_created,
            :content        => version.content,
            :date           => self.created_at,
            :author         => version.author
          }
        else
          updates << {
            :type           => :info_updated,
            :content_from   => self.versions[i + 1].content,
            :content_to     => version.content,
            :date           => self.versions[i + 1].created_at,
            :author         => self.versions[i + 1].author
          }
        end
      end
      
    else
      updates << {
        :type           => :info_created,
        :content        => self.content,
        :date           => self.created_at,
        :author         => self.last_revision_author 
      }
    end
    
    updates
  end
  
  private
    def interval_between_versions_passed?
      DateTime.now > (self.updated_at || DateTime.now) + APP_CONFIG['interval_between_versions'].to_i.minutes
    end
  
    def change_by_other_user?
      self.last_revision_author_id_changed?
    end
    
    def create_history
      if !new_record? && content_changed? && (interval_between_versions_passed? || change_by_other_user?)
        InformationVersion.create(
          :content =>       self.content_was, 
          :until =>         DateTime.now, 
          :information =>   self, 
          :author =>        last_revision_author
        )
      end
    end
end
