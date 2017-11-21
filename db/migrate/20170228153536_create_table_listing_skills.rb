class CreateTableListingSkills < ActiveRecord::Migration
  def change
    create_table :categories_listings do |t|
      t.integer :category_id
      t.integer :listing_id
    end
  end
end
