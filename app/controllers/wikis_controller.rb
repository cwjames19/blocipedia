class WikisController < ApplicationController
	
	before_action :authenticate_user, :except => [:show, :index]
	
	def new
		@wiki = Wiki.new
	end

	def create
		@user = current_user
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
		@wiki = Wiki.find(params[:id])
	end
	
	def index
	end

	def destroy
		@wiki = Wiki.find(params[:id])
		
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
		authorize @wiki
	end

	def update
		@wiki = Wiki.find(params[:id])
		authorize @wiki
		
		if @wiki.update_attributes(wiki_params)
			flash[:notice] = "Wiki updated"
			redirect_to [@wiki]
		else
			flash[:error] = "Sorry, there was a problem while trying to update the wiki. please try again later."
			render :edit
		end
	end
	
	private
	
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
