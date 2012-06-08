class Article < ActiveRecord::Base
  require 'open-uri'
  
  class WikiExistenceValidator < ActiveModel::Validator
    VALID_WIKIPEDIA_LINK = %r{(?:http://)?([^\.]+)\.wikipedia\.org/wiki/(.+)}
    
    def validate(record)
      unless record.lang_code? && record.title?
        record.errors[:url] << 'page Wikipedia inexistante'
      end
    end
  end
  
  attr_accessible :url, :informations_attributes, :main_information, :main_information_attributes, :image_uri
  
  validates_with WikiExistenceValidator, :on => :create, :if => proc {|a| a['title'] != 'Wikibref'}
  
  validates_uniqueness_of :title, :scope => :lang_code
  
  has_many  :informations, :conditions => {:is_main => false}, :order => 'score ASC'
  has_one   :main_information, :class_name => "Information", :conditions => {:is_main => true}
  has_many  :all_information, :class_name => "Information"
  
  belongs_to :creator, :class_name => "Author"
  belongs_to :last_modifier, :class_name => "Author"
  
  accepts_nested_attributes_for :informations, :reject_if => proc {|a| a['content'].blank?}
  accepts_nested_attributes_for :main_information, :reject_if => proc {|a| a['content'].blank?}
  
  serialize :images
  
  attr_accessor :user
  
  def url=(arg)
    @url = prefix_url_if_necessary(arg)
    @url = encode_url_if_necessary(@url)
    
    if @url.match WikiExistenceValidator::VALID_WIKIPEDIA_LINK
      begin
        page = Nokogiri::HTML(grab_original_url_content)
        self.images = extract_images(page)
        self.lang_code = $1
        self.title = AppTools::SlugNormalizer.decode($2)
      rescue Exception => e
        errors[:url] << 'page Wikipedia incorrecte ou inexistante'
      end
    else
      errors[:url] << 'page Wikipedia inexistante'
    end
  end
  
  def url
    @url || url_original
  end
  
  def url_original
    "http://#{lang_code}.wikipedia.org/wiki/#{slug}"
  end
  
  def slug
    AppTools::SlugNormalizer.encode(title)
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
  
  def last_modifier=(user)
    super
    tell_informations_about_last_modifer
  end
  
  def history
    updates = []
    
    # Creation
    updates << {
      :type   => :creation,
      :date   => self.created_at
    }
    
    # Informations
    self.all_information.includes(:versions).each do |info|
      updates = updates + info.history
    end
    
    updates
  end
  
  private
    def prefix_url_if_necessary(url)
      if url.starts_with? "http://"
        url
      else
        "http://" + url
      end
    end
    
    def encode_url_if_necessary(url)
      begin
        url.encode("US-ASCII")
        url
      rescue   
        URI.encode(url)
      end
    end

    def extract_images(doc)
      imgs = []

      doc.css("#content img").each do |img|
        if img[:height].to_i > APP_CONFIG['minimal_image_s_height_acceptable']
          imgs << {:src => img[:src], :alt => img[:alt]}
        end
      end
      
      imgs.uniq
    end
    
    def grab_original_url_content
      open(url)
    end
    
    def tell_informations_about_last_modifer
      informations.each{ |info| info.last_revision_author = last_modifier if info.changed? || info.new_record? }
      main_information.last_revision_author = last_modifier if main_information && (main_information.changed? || main_information.new_record?)
    end
end