class ChangePersonImagesPersonId < ActiveRecord::Migration
  def change
    change_column :person_images, :person_id, :string
  end
end
