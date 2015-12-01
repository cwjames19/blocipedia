class AddDowngradedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :downgraded_at, :datetime
  end
end
