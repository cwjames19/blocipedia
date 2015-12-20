class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :collaborators
  has_many :users, through: :collaborators
  
  before_save :define_title_lower
  after_create :add_creator_as_collaborator
  
  validates :title, presence: true, uniqueness: true
  validates :user, presence: true
  
  def self.default_scope
    Wiki.all.order(title_lower: :asc)
  end
  
  private
  
  def add_creator_as_collaborator
    if self.private?
      collaborator = self.collaborators.build(wiki_id: self.id, user_id: self.user.id, user_email: self.user.email)
      collaborator.save
    end
  end
  
  def define_title_lower
    self.title_lower = self.title.downcase
  end
  
end
