class CreateLegalResourceSearches < ActiveRecord::Migration
  def change
    create_table :legal_resource_searches do |t|
      t.string :name
      t.string :free_text
      t.date :date_from
      t.date :date_to
      t.string :legal_resource_name
      t.integer :user_id

      t.timestamps
    end

    create_table :legal_resource_searches_publishers, :id => false do |t|
      t.integer :legal_resource_search_id
      t.integer :publisher_id
    end

    create_table :document_types_legal_resource_searches, :id => false do |t|
      t.integer :legal_resource_search_id
      t.integer :document_type_id
    end

    create_table :child_topics_legal_resource_searches, :id => false do |t|
      t.integer :legal_resource_search_id
      t.integer :child_topic_id
    end

    create_table :legal_resource_searches_refugee_topics, :id => false do |t|
      t.integer :legal_resource_search_id
      t.integer :refugee_topic_id
    end

    create_table :legal_resource_searches_process_topics, :id => false do |t|
      t.integer :legal_resource_search_id
      t.integer :process_topic_id
    end

    create_table :keywords_legal_resource_searches, :id => false do |t|
      t.integer :legal_resource_search_id
      t.integer :keyword_id
    end


  end
end
