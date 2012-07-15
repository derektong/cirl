class CreateChildLinks < ActiveRecord::Migration
  def change
    create_table :child_links do |t|
      t.integer :child_topic_id
      t.integer :keyword_id
      t.boolean :required

      t.timestamps
    end

    add_index :child_links, :child_topic_id
    add_index :child_links, :keyword_id
    add_index :child_links, [:child_topic_id, :keyword_id], unique: true
  end
end
