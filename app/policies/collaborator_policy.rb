class CollaboratorPolicy < ApplicationPolicy
	
	class Scope
	end
	
	def new?
		user.present?
	end
	
	def create?
		user.present?
	end

	def destroy?
		user.present?
	end

end