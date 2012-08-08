class CreateLegalResources < ActiveRecord::Migration
  def change
    create_table :legal_resources do |t|
      t.string :name
      t.integer :document_type_id
      t.date :publish_date
      t.text :fulltext

      t.timestamps
    end

    create_table :child_topics_legal_resources, :id => false do |t|
      t.integer :child_topic_id
      t.integer :legal_resource_id
    end

    create_table :keywords_legal_resources, :id => false do |t|
      t.integer :keyword_id
      t.integer :legal_resource_id
    end

    create_table :legal_resources_process_topics, :id => false do |t|
      t.integer :process_topic_id
      t.integer :legal_resource_id
    end

    create_table :legal_resources_refugee_topics, :id => false do |t|
      t.integer :refugee_topic_id
      t.integer :legal_resource_id
    end

    create_table :legal_resources_users, :id => false do |t|
      t.integer :user_id
      t.integer :legal_resource_id
    end


  end
end
