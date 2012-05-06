class Search
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :keywords
  
  validates_presence_of :keywords
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end unless attributes.nil?
  end
  
  def persisted?
    false
  end
end