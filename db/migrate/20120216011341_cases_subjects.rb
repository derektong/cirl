class CasesSubjects < ActiveRecord::Migration
  def up
    create_table :cases_subjects, :id => false do |t|
      t.integer :case_id
      t.integer :subject_id
    end
  end

  def down
    drop_table :cases_subjects
  end
end
