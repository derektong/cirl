class AddIndexToSubjectDescription < ActiveRecord::Migration
  def change
    add_index :subjects, :description, :unique => true
  end
end
