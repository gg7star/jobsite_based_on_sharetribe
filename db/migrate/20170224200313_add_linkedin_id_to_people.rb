class AddLinkedinIdToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :linkedin_id, :string
    
    add_index :people, :linkedin_id, :unique => true
  end

  def self.down
    remove_index :people, :linkedin_id
    
    remove_column :people, :linkedin_id
  end
end
