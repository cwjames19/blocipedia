class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable,
         :recoverable, :rememberable, :validatable#, :confirmable
         
  has_many :wikis
  has_many :collaborators
  has_many :wikis, through: :collaborators
  
  validates :username, presence: true
  
  attr_accessor :upgraded_at, :downgraded_at
  enum role: [:standard, :premium, :admin]
  after_initialize :set_default_role, :if => :new_record?
  
  def update_upgraded_at(timestamp)
    self.upgraded_at = timestamp
    save
  end
  
  private
  
  def set_default_role
    self.role ||= :standard
  end
end
