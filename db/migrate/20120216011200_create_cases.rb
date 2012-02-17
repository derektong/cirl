class CreateCases < ActiveRecord::Migration
  def change
    create_table :cases do |t|
      t.string :name
      t.date :decision_date
      t.string :country_origin
      t.integer :court_id

      t.timestamps
    end
  end
end
