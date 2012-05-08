class ArticlesController < ApplicationController
  def show
    slug_to_title = SlugNormalizer.decode(params[:slug])
    
    @article = Article.where(:title => slug_to_title).includes(:informations).first
    
    unless @article
      redirect_to new_article_path(:slug => slug_to_title)
    end
  end
  
  def edit
    @article = Article.find params[:id]
  end
  
  def new
    @article = Article.new
  end
  
  def create
    @article = Article.new(params[:article])
    
    if @article.save
      redirect_to edit_article_path(@article)
    else
      flash.now[:alert] = t(".create.errors");
      render :action => "new"
    end
  end
  
  def update
    @article = Article.find(params[:id])

    @article.update_attributes params[:article]
    
    flash[:notice] = t(".update.article_successfully_edited");
    redirect_to wiki_like_path(@article)
  end
  
  # The title of the article in the url is slightly different of the database one, so do some encoding here
  class SlugNormalizer
    def self.decode(slug)
      slug ||= ""
      slug = URI.decode(slug)
      slug.gsub('_', ' ')
    end
    
    def self.encode(title)
      title ||= ""
      title = URI.encode(title)
      title.gsub(' ', '_')
    end
  end
end
