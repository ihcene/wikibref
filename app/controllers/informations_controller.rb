class InformationsController < ApplicationController
  def destroy
    information = Article.find(params[:article_id]).informations.find(params[:id])
    
    if information
      information.destroy
      respond_to do |format|
        format.js { render :json => information }
      end
    end
  end
end
