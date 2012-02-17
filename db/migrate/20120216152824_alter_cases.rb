class AlterCases < ActiveRecord::Migration
  def change
    add_column :cases, :respondent, :string
    add_column :cases, :claimant, :string
    remove_column :cases, :name
  end

end
