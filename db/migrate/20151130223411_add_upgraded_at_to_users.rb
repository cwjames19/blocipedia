class AddUpgradedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :upgraded_at, :datetime
  end
end
