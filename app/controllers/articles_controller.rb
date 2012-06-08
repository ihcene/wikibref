class ArticlesController < ApplicationController
  def show
    slug_to_title = AppTools::SlugNormalizer.decode(params[:slug])
    
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
    @article.creator = user 
    
    if @article.save
      redirect_to edit_article_path(@article)
    else
      flash.now[:alert] = t(".create.errors");
      render :action => "new"
    end
  end
  
  def update
    @article = Article.find(params[:id])
    
    @article.attributes = params[:article]
    @article.last_modifier = user
    
    if @article.save
      flash[:notice] = t(".update.article_successfully_edited");
      redirect_to wiki_like_path(:slug => @article.slug)
    else
      flash.now[:alert] = t(".create.errors");
      render :action => "edit"
    end
  end
  
  def history
    @article = Article.find params[:id]
  end
  
  def reload_pictures
    @article = Article.find(params[:id])
    @article.reload_pictures
    
    redirect_to edit_article_url(@article)
  end
end
