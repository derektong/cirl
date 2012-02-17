class CasesIssues < ActiveRecord::Migration
  def up
    create_table :cases_issues, :id => false do |t|
      t.integer :case_id
      t.integer :issue_id
    end
  end

  def down
    drop_table :cases_issues
  end
end
