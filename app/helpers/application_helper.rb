module ApplicationHelper
  def title(titre)
    content_for(:title) do 
      strip_tags titre
    end
    titre
  end
end
