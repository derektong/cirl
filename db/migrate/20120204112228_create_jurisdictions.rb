class CreateJurisdictions < ActiveRecord::Migration
  def self.up 
    create_table :jurisdictions do |t|
      t.string  :name, :limit => 128, :null => false
    end
  end
  def self.down
    drop_table :jurisdictions
  end
end
