class AddValidUntilTurnaroundToListing < ActiveRecord::Migration
  def change
    add_column :listings, :valid_until_turnaround, :integer, default: 1
  end
end
