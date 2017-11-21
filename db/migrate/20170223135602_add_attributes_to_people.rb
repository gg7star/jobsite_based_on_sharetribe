class AddAttributesToPeople < ActiveRecord::Migration
  def change
    add_column :people, :overall_name, :string
  end
end
