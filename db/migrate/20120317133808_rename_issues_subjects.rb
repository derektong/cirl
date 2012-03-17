class RenameIssuesSubjects < ActiveRecord::Migration
  def change
    rename_table :cases_issues, :case_refugee_topics
    rename_table :cases_subjects, :case_child_topics
    rename_table :issues, :refugee_topics
    rename_table :subjects, :child_topics
  end

end
