class CreateSearchUser < ActiveRecord::Migration
  def change
    add_column :case_searches, :user_id, :integer
  end
end
