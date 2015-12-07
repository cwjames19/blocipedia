class WikiPolicy < ApplicationPolicy
	
	class Scope
		attr_reader :user, :scope
		
		def initialize(user, scope)
			@user = user
			@scope = scope
		end
		
		def resolve
			if user.premium? || user.admin?
				scope.all
			else
				scope.where(private: false)
			end
		end
	end
	
	def new?
		user.present?
	end
	
	def show?
		!wiki.private? || user.admin? || wiki.user == user
	end
	
	def create?
		user.present?
	end
	
	def index?
	end
	
	def destroy?
		user.admin? || (wiki.private? && wiki.user == user)
	end
	
	def edit?
		user.present?
	end
	
	def update?
		user.present?
	end
	
end