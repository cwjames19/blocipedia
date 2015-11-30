class WikiPolicy < ApplicationPolicy
	
	def new
	end
	
	def show
	end
	
	def create
	end
	
	def index
	end
	
	def destroy
	end
	
	def edit
		user.present?
	end
	
	def update?
		user.present?
	end
	
end