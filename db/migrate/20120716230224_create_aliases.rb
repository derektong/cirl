class CreateAliases < ActiveRecord::Migration
  def change
    create_table :aliases do |t|
      t.integer :keyword_id
      t.string :description

      t.timestamps
    end
  end
end
