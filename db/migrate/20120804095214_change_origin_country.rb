class ChangeOriginCountry < ActiveRecord::Migration
  def change
    remove_column :cases, :country_origin
    add_column :cases, :country_origin_id, :integer
  end
end
