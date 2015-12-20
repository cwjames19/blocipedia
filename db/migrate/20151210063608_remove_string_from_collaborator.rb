class RemoveStringFromCollaborator < ActiveRecord::Migration
  def change
    remove_column :collaborators, :string, :string
  end
end
