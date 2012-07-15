class CreateProcessLinks < ActiveRecord::Migration
  def change
    create_table :process_links do |t|
      t.integer :process_topic_id
      t.integer :keyword_id
      t.boolean :required

      t.timestamps
    end

    add_index :process_links, :process_topic_id
    add_index :process_links, :keyword_id
    add_index :process_links, [:process_topic_id, :keyword_id], unique: true
  end
end
