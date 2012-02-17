class AddIndexToIssueDescription < ActiveRecord::Migration
  def change
    add_index :issues, :description, :unique => true
  end
end


