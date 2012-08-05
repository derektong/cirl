class CreateCountryOrigins < ActiveRecord::Migration
  def change
    create_table :country_origins do |t|
      t.string :name

      t.timestamps
    end
  end
end
