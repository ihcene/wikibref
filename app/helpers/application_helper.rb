module ApplicationHelper
  def title(titre)
    content_for(:title) do 
      titre
    end
    titre
  end
end
