class CreateRefugeeLinks < ActiveRecord::Migration
  def change
    create_table :refugee_links do |t|
      t.integer :refugee_topic_id
      t.integer :keyword_id
      t.boolean :required

      t.timestamps
    end

    add_index :refugee_links, :refugee_topic_id
    add_index :refugee_links, :keyword_id
    add_index :refugee_links, [:refugee_topic_id, :keyword_id], unique: true
  end
end
