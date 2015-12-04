class WikiPolicy < ApplicationPolicy
	
	class Scope
		attr_reader :scope, :user
		
		def initialize(user, scope)
			@scope = scope
			@user = user
		end
		
		def resolve
			scope.all
		end
	end
	
	def new?
		user.present?
	end
	
	def show?
	end
	
	def create?
		user.present?
	end
	
	def index?
	end
	
	def destroy?
		user.admin?
	end
	
	def edit?
		user.present?
	end
	
	def update?
		user.present?
	end
	
end