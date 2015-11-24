class WikisController < ApplicationController
  
  before_action :authenticate_user, :except => [:show]
  
  def new
    @wiki = Wiki.new
  end

  def create
    @user = User.find(params[:user_id])
    @wiki = @user.wikis.build(wiki_params)
    
    if @wiki.save
      flash[:notice] = "Wiki saved!"
      redirect_to root_path
    else
      flash[:error] = "An error occured while saving you article. Please try again."
      redirect_to root_path
    end
  end

  def show
  end

  def destroy
  end

  def edit
  end

  def update
  end
  
  private
  
  def authenticate_user
    unless current_user
      redirect_to new_user_session_path
    end
  end
  
  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end
  
end
