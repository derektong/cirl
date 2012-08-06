class CreateAbstracts < ActiveRecord::Migration
  def change
    add_column :cases, :abstract, :string
  end
end
