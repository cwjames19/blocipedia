class AddTitleLowerToWiki < ActiveRecord::Migration
  def change
    add_column :wikis, :title_lower, :string
  end
end
