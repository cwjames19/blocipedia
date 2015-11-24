class Wiki < ActiveRecord::Base
  belongs_to :user
  
  validates :title, presence: true, uniqueness: true
  validates :user, presence: true
end
