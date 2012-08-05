class Create < ActiveRecord::Migration
  def change
    create_table :case_searches_users, :id => false do |t|
      t.integer :case_search_id
      t.integer :user_id
    end
  end
end
