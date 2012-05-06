class Article < ActiveRecord::Base
  class WikiExistenceValidator < ActiveModel::Validator
    require 'open-uri'
    
    VALID_WIKIPEDIA_LINK = %r{(?:http://)?([^\.]+)\.wikipedia\.org/wiki/(.+)}
    
    def validate(record)
      begin
        open record.url, :proxy => true
      rescue
        record.errors[:url] << 'Page Wikipedia inexistante'
      end
    end
  end
  
  attr_accessible :url, :informations_attributes, :main_information, :main_information_attributes
  
  validates_format_of :url, :with => WikiExistenceValidator::VALID_WIKIPEDIA_LINK, :on => :create
  validates_with WikiExistenceValidator, :on => :create
  
  validates_uniqueness_of :title, :scope => :lang_code
  
  has_many  :informations, :conditions => {:is_main => false}, :order => 'score ASC'
  has_one   :main_information, :class_name => "Information", :conditions => {:is_main => true}
  
  before_validation :prefix_url, :on => :create
  
  accepts_nested_attributes_for :informations, :reject_if => proc {|a| a['content'].blank?}
  accepts_nested_attributes_for :main_information, :reject_if => proc {|a| a['content'].blank?}
  
  def url=(arg)
    @url = arg
    arg.match WikiExistenceValidator::VALID_WIKIPEDIA_LINK
    
    self.lang_code = $1
    self.title = ArticlesController::SlugNormalizer.decode($2)
  end
  
  def url
    @url || url_original
  end
  
  def url_original
    "http://#{lang_code}.wikipedia.org/wiki/#{slug}"
  end
  
  def slug
    ArticlesController::SlugNormalizer.encode(title)
  end
  
  private
    def prefix_url
      self.url = "http://" + self.url unless self.url.starts_with? "http://"
    end
end