class WikiPolicy < ApplicationPolicy
	
	def new
		user.present?
	end
	
	def show
	end
	
	def create
		user.present?
	end
	
	def index
	end
	
	def destroy
		user.present?
	end
	
	def edit
		user.present?
	end
	
	def update?
		user.present?
	end
	
end