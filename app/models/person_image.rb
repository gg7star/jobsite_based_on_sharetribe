# == Schema Information
#
# Table name: person_images
#
#  id                 :integer          not null, primary key
#  person_id          :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class PersonImage < ActiveRecord::Base
  # TODO Rails 4, Remove
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :person, touch: true

  # see paperclip (for image_processing column)
  has_attached_file :image, :styles => {
        :small_3x2 => "240x160#",
        :medium => "360x270#",
        :thumb => "120x120#",
        :original => "#{APP_CONFIG.original_image_width}x#{APP_CONFIG.original_image_height}>",
        :big => "408x408#",
        :email => "150x100#",
        :square => "408x408#",
        :card_small => "153x102#",
        :square_2x => "816x816#"}

  validates_attachment_size :image, :less_than => APP_CONFIG.max_image_filesize.to_i, :unless => Proc.new {|model| model.image.nil? }
  validates_attachment_content_type :image,
                                    :content_type => ["image/jpeg", "image/png", "image/gif", "image/pjpeg", "image/x-png"], # the two last types are sent by IE.
                                    :unless => Proc.new {|model| model.image.nil? }
end
