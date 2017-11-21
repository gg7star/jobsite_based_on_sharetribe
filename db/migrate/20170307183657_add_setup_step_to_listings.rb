class AddSetupStepToListings < ActiveRecord::Migration
  def change
  	add_column(:listings, :setup_step, :integer, default: 1)
  end
end
