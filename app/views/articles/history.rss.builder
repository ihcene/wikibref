xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do

    xml.title       "#{@article.title} [#{@article.lang_code.upcase}]"
    xml.link        url_for article_path(@article)
    xml.description "Wikibref.org — L'encyclopédie élexir"
    

    sort(@article.history).each do |maj|
      xml.item do
        xml.title       t("history.labels.#{maj[:type]}")
        xml.link        url_for article_url(@article)
        xml.description render(:partial => 'history.html.erb', :locals => {:maj => maj})
      end
    end

  end
end