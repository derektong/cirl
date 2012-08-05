class CreateCaseSearches < ActiveRecord::Migration
  def change
    create_table :case_searches do |t|
      t.string :name
      t.string :free_text
      t.date :date_from
      t.date :date_to
      t.string :case_name

      t.timestamps
    end
  end
end
