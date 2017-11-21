class AddYearsOfExperienceToCategoriesPeople < ActiveRecord::Migration
  def change
    add_column :categories_people, :years_of_experience, :integer
  end
end
