class AddAccountSetupStepToPeople < ActiveRecord::Migration
  def change
    add_column :people, :account_setup_step, :integer, default: 1
  end
end
