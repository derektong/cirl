class AddFulltextToCases < ActiveRecord::Migration
  def change
    add_column :cases, :fulltext, :text

  end
end
