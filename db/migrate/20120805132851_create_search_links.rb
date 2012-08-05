class CreateSearchLinks < ActiveRecord::Migration
  def change
    create_table :case_searches_country_origins, :id => false do |t|
      t.integer :case_search_id
      t.integer :country_origin_id
    end

    create_table :case_searches_jurisdictions, :id => false do |t|
      t.integer :case_search_id
      t.integer :jurisdiction_id
    end

    create_table :case_searches_courts, :id => false do |t|
      t.integer :case_search_id
      t.integer :court_id
    end

    create_table :case_searches_child_topics, :id => false do |t|
      t.integer :case_search_id
      t.integer :child_topic_id
    end

    create_table :case_searches_refugee_topics, :id => false do |t|
      t.integer :case_search_id
      t.integer :refugee_topic_id
    end

    create_table :case_searches_process_topics, :id => false do |t|
      t.integer :case_search_id
      t.integer :process_topic_id
    end

    create_table :case_searches_keywords, :id => false do |t|
      t.integer :case_search_id
      t.integer :keyword_id
    end

  end
end
