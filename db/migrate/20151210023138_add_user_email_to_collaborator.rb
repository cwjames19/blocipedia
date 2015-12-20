class AddUserEmailToCollaborator < ActiveRecord::Migration
  def change
    add_column :collaborators, :user_email, :string
  end
end
