class WikiPolicy < ApplicationPolicy
	
	class Scope
		attr_reader :user, :scope
		
		def initialize(user, scope)
			@user = user
			@scope = scope
		end
		
		def resolve
			wikis = []
			if user
				if user.role == 'admin'
					wikis = scope.all
				else
					all_wikis = scope.all
					wikis = []
					all_wikis.each do |wiki|
						if !wiki.private? || wiki.user == user || wiki.users.include?(user)
							wikis << wiki
						end
					end
				end
			else
				wikis = scope.where(private: false)
			end
			wikis
		end
	end
	
	def new?
		user.present?
	end
	
	def show?
		!wiki.private? || ( user.present? && user.admin? || wiki.users.include?(user) )
	end
	
	def create?
		user.present?
	end
	
	def index?
	end
	
	def destroy?
		user.present? && ( user.admin? || wiki.user == user )
	end
	
	def edit?
		user.present? && show?
	end
	
	def update?
		edit?
	end
	
end