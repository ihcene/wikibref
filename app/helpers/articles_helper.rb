module ArticlesHelper
  def bold_keywords(str)
    return "" if str.nil?
    sanitize(str.gsub(/\*([^\s]+(?:\s+[^\s]+){0,1})\*/) { |match| "<strong>#{$1}</strong>" })
  end
  
  def form_already_showed?
    if @form_already_showed.nil?
      @form_already_showed = true
      false
    else
      true
    end
  end
  
  def options(information, position)
    options = {:class => 'score'}
    options[:value] = position unless position.nil?
    options 
  end
end
