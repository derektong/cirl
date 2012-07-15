class CreateProcessTopics < ActiveRecord::Migration
  def change
    create_table :process_topics do |t|

      t.string :description
      t.timestamps
    end

    create_table :cases_process_topics, :id => false do |t|
      t.integer :case_id
      t.integer :process_topic_id
    end
  end
end
