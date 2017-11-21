class ChangeSkillPersonId < ActiveRecord::Migration
  def change
    change_column :categories_people, :person_id, :string
  end
end
