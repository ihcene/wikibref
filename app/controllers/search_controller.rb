class SearchController < ApplicationController
  def index
    article = Article.where(:title => params[:search][:keywords]).first
    
    if article.present?
      redirect_to wiki_like_path(article.slug)
    else
      redirect_to new_article_path
    end
  end
end
