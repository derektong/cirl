class CreateLegalBriefs < ActiveRecord::Migration
  def change
    create_table :legal_briefs do |t|
      t.string :name
      t.integer :court_id
      t.integer :organisation_id
      t.date :document_date
      t.text :overview
      t.text :fulltext
      t.integer :user_id

      t.timestamps
    end

    create_table :child_topics_legal_briefs, :id => false do |t|
      t.integer :child_topic_id
      t.integer :legal_brief_id
    end

    create_table :keywords_legal_briefs, :id => false do |t|
      t.integer :keyword_id
      t.integer :legal_brief_id
    end

    create_table :legal_briefs_process_topics, :id => false do |t|
      t.integer :process_topic_id
      t.integer :legal_brief_id
    end

    create_table :legal_briefs_refugee_topics, :id => false do |t|
      t.integer :refugee_topic_id
      t.integer :legal_brief_id
    end

  end
end
