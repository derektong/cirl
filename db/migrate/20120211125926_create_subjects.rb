class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :description

      t.timestamps
    end
  end
end
