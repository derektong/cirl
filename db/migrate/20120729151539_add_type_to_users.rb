class AddTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_type, :integer, default: 0

  end
end
