class RenameIssuesSubjectsColumns < ActiveRecord::Migration
  def change
    rename_table :case_child_topics, :cases_child_topics
    rename_table :case_refugee_topics, :cases_refugee_topics
    rename_column :cases_refugee_topics, :issue_id, :refugee_topic_id
    rename_column :cases_child_topics, :subject_id, :child_topic_id
  end
end
