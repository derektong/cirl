class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|

      t.string :description
      t.timestamps
    end

    create_table :cases_keywords, :id => false do |t|
      t.integer :case_id
      t.integer :keyword_id
    end
  end
end
