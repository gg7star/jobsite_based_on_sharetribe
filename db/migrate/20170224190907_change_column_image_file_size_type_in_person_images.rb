class ChangeColumnImageFileSizeTypeInPersonImages < ActiveRecord::Migration
  def change
    change_column :person_images, :image_file_size, :integer
  end
end
