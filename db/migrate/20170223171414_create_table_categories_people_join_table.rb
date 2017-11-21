class CreateTableCategoriesPeopleJoinTable < ActiveRecord::Migration
  def change
    create_table :categories_people do |t|
      t.integer :category_id
      t.integer :person_id
    end
  end
end
