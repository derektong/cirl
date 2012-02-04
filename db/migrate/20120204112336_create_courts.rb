class CreateCourts < ActiveRecord::Migration
  def self.up
    create_table :courts do |t|
      t.string  :title, :limit => 128, :null => false
      t.integer :jurisdiction_id
    end
  end
  def self.down
    drop_table :jurisdictions
  end
end
