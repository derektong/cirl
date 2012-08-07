class CreateLegalBriefsUsers < ActiveRecord::Migration
  def change
    create_table :legal_briefs_users, :id => false do |t|
      t.integer :legal_brief_id
      t.integer :user_id
    end
  end
end
