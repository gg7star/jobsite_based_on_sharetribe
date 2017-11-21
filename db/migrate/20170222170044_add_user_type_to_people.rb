class AddUserTypeToPeople < ActiveRecord::Migration
  def change
    add_column :people, :user_type, :string, default: ""
  end
end
