class WikisController < ApplicationController
	
	before_action :authenticate_user, :except => [:show, :index]
	
	def new
		@wiki = Wiki.new
	end

	def create
		@user = current_user
		@wiki = @user.wikis.build(wiki_params)
		@wiki.user = @user
		
		if @wiki.save
			flash[:notice] = "Wiki saved!"
			redirect_to @wiki
		else
			flash[:error] = "An error occured while saving your article. Please try again."
			redirect_to root_path
		end
	end

	def show
		@wiki = Wiki.find(params[:id])
		authorize @wiki
	end
	
	def index
		@wikis = policy_scope(Wiki)
	end

	def destroy
		@wiki = Wiki.find(params[:id])
		authorize @wiki
		
		if @wiki.destroy
			flash[:notice] = "Wiki deleted."
			redirect_to wikis_path
		else
			flash[:error] = "Sorry, an error occurred. Please try again later."
			redirect_to wiki_path(@wiki)
		end
	end

	def edit
		@wiki = Wiki.find(params[:id])
		@collaborator = Collaborator.new
		@users = @wiki.users
		authorize @wiki
	end

	def update
		@wiki = Wiki.find(params[:id])
		authorize @wiki
		
		if @wiki.update_attributes(wiki_params)
			flash[:notice] = "Wiki updated"
			redirect_to @wiki
		else
			flash[:error] = "Sorry, there was a problem while trying to update the wiki. please try again later."
			render :edit
		end
	end
	
	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  private
  
  def user_not_authorized
    flash[:alert] = "You do not have permission to do that."
    redirect_to root_path
  end
	
	def authenticate_user
		unless current_user
			flash[:error] = "You must be logged in to do that!"
			redirect_to new_user_session_path
		end
	end
	
	def wiki_params
		params.require(:wiki).permit(:title, :body, :private)
	end
	
end
