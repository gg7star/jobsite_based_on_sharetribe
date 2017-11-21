class AddFieldsToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :country, :string
    add_column :locations, :city, :string
    add_column :locations, :postal_code, :string
    add_column :locations, :distance_limit, :integer
    add_column :locations, :distance_limit_unit, :string
  end
end
