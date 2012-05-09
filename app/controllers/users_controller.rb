class UsersController < ApplicationController
  def subscribe
    @author = Author.new
  end
  
  def create
    @author = Author.create(params[:author])
    
    if @author.valid?
      @author.save
      redirect_to root_path, :notice => "Compte cree avec succes", 
    else
      flash.now[:alert] = "Des erreurs se sont glisses dans votre formulaire"
      render :action => "subscribe"
    end
  end

  def login
    author = Author.find_by_email(params[:author][:email])
    
    if author
      if author.authenticate(params[:author][:password])
        session[:author_id] = author.id
        redirect_to :back, :notice => "Vous etes maintenant authentifie en tant que #{author.username}"
      else
        access_denied
      end
    else
      access_denied
    end
  end
  
  def logout
    session[:author_id] = nil
    redirect_to root_path, :notice => "Vous etes maintenant deconnectes"
  end
  
  private
    def access_denied
      redirect_to :back, :alert => "Acces refuse. Nom d'utilisateur ou mot de passe incorrect"
    end
end
