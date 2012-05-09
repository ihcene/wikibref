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
  
  attr_accessible :url, :informations_attributes, :main_information, :main_information_attributes, :image_uri
  
  validates_format_of :url, :with => WikiExistenceValidator::VALID_WIKIPEDIA_LINK, :on => :create
  validates_with WikiExistenceValidator, :on => :create, :if => proc {|a| a['title'] != 'Wikibref'}
  
  validates_uniqueness_of :title, :scope => :lang_code
  
  has_many  :informations, :conditions => {:is_main => false}, :order => 'score ASC'
  has_one   :main_information, :class_name => "Information", :conditions => {:is_main => true}
  
  belongs_to :creator, :class_name => "Author"
  belongs_to :last_modifier, :class_name => "Author"
  
  before_validation :prefix_url, :on => :create
  
  accepts_nested_attributes_for :informations, :reject_if => proc {|a| a['content'].blank?}
  accepts_nested_attributes_for :main_information, :reject_if => proc {|a| a['content'].blank?}
  
  serialize :images
  
  attr_accessor :user
  
  def url=(arg)
    @url = arg
    arg.match WikiExistenceValidator::VALID_WIKIPEDIA_LINK
    
    self.lang_code = $1
    self.title = ArticlesController::SlugNormalizer.decode($2)
    self.images = extract_images
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
  
  def image
    image_uri || images.try(:first).try(:[], :src)
  end
  
  def image_fullsize
    parts = image.split('/')
    parts.reject!{ |e| e == "thumb"}
    parts.pop
    parts.join('/')
  end
  
  def reload_pictures
    self.images = extract_images
    save    
  end
  
  private
    def prefix_url
      self.url = "http://" + self.url unless self.url.starts_with? "http://"
    end

    def extract_images
      doc = Nokogiri::HTML(open(url)) ;

      imgs = []

      doc.css("#content img").each do |img|
        if img[:height].to_i > APP_CONFIG['minimal_image_s_height_acceptable']
          imgs << {:src => img[:src], :alt => img[:alt]}
        end
      end
      
      imgs.uniq
    end
end