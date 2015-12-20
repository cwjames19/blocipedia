class CollaboratorsController < ApplicationController
	
	def create
		@wiki = Wiki.find(params[:wiki_id])
		user_email = params[:collaborator][:user_email]
		user = User.where(email: user_email).first
		authorize @wiki, :edit?
		
		if @wiki.users.all.include?(user)
			flash[:alert] = "That user is already a collaborator on this wiki."
		else
			collaborator = @wiki.collaborators.build(wiki: @wiki, user: user, user_email: user_email)
			if collaborator.save
				flash[:notice] = "Collaborator added."
			else
				flash[:alert] = "Sorry, an error occurred. Please try again later."
			end
		end
		
		redirect_to @wiki
	end
	
	def destroy
		wiki = Wiki.find(params[:wiki_id])
		@collaborator = Collaborator.find(params[:id])
		authorize @collaborator, :destroy?
		
		if @collaborator.user_id == wiki.user.id
			flash[:alert]  = "You can not drop a wiki's creator as a collaborator"
			redirect_to wiki
		end
		
		if @collaborator.delete
			flash[:notice] = "Collaborator deleted!"
		else
			flash[:alert] = "Sorry, an error occurred. Please try again later."
		end
		
		redirect_to wiki
	end

end