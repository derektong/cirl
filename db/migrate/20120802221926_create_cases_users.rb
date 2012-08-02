class CreateCasesUsers < ActiveRecord::Migration
  def change
    create_table :cases_users, :id => false do |t|
      t.integer :case_id
      t.integer :user_id
    end
  end
end
