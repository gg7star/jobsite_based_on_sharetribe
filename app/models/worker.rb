# == Schema Information
#
# Table name: people
#
#  id                                 :string(22)       not null, primary key
#  uuid                               :binary(16)       not null
#  community_id                       :integer          not null
#  created_at                         :datetime
#  updated_at                         :datetime
#  is_admin                           :integer          default(0)
#  locale                             :string(255)      default("fi")
#  preferences                        :text(65535)
#  active_days_count                  :integer          default(0)
#  last_page_load_date                :datetime
#  test_group_number                  :integer          default(1)
#  username                           :string(255)      not null
#  email                              :string(255)
#  encrypted_password                 :string(255)      default(""), not null
#  legacy_encrypted_password          :string(255)
#  reset_password_token               :string(255)
#  reset_password_sent_at             :datetime
#  remember_created_at                :datetime
#  sign_in_count                      :integer          default(0)
#  current_sign_in_at                 :datetime
#  last_sign_in_at                    :datetime
#  current_sign_in_ip                 :string(255)
#  last_sign_in_ip                    :string(255)
#  password_salt                      :string(255)
#  given_name                         :string(255)
#  family_name                        :string(255)
#  phone_number                       :string(255)
#  description                        :text(65535)
#  image_file_name                    :string(255)
#  image_content_type                 :string(255)
#  image_file_size                    :integer
#  image_updated_at                   :datetime
#  image_processing                   :boolean
#  facebook_id                        :string(255)
#  authentication_token               :string(255)
#  community_updates_last_sent_at     :datetime
#  min_days_between_community_updates :integer          default(1)
#  deleted                            :boolean          default(FALSE)
#  cloned_from                        :string(22)
#  linkedin_id                        :string(255)
#  user_type                          :string(255)      default("")
#  overall_name                       :string(255)
#  account_setup_step                 :integer          default(1)
#  fixed_online_status                :string(255)
#  last_activity_at                   :datetime
#  last_seen_at                       :datetime
#
# Indexes
#
#  index_people_on_authentication_token          (authentication_token)
#  index_people_on_community_id                  (community_id)
#  index_people_on_email                         (email) UNIQUE
#  index_people_on_facebook_id                   (facebook_id)
#  index_people_on_facebook_id_and_community_id  (facebook_id,community_id) UNIQUE
#  index_people_on_id                            (id)
#  index_people_on_linkedin_id                   (linkedin_id) UNIQUE
#  index_people_on_reset_password_token          (reset_password_token) UNIQUE
#  index_people_on_username                      (username)
#  index_people_on_username_and_community_id     (username,community_id) UNIQUE
#  index_people_on_uuid                          (uuid) UNIQUE
#

class Worker < Person
  PROP_NAME = "worker"

  has_many :skills, foreign_key: "person_id"
  has_many :images, dependent: :destroy, class_name: "PersonImage", foreign_key: "person_id"
  has_many :offers, foreign_key: "person_id" 

  accepts_nested_attributes_for :skills, allow_destroy: true
  accepts_nested_attributes_for :images, allow_destroy: true

  validates :overall_name, presence: true
  validates :overall_name, length: {minimum: 3}
  validate :has_atleast_one_location
  validate :has_atleast_one_skill
  validate :description_present_and_has_length

  attr_accessible(:skills_attributes, :images_attributes, :location_attributes, :description, :overall_name, :image, :user_type, :account_setup_step)

  private

  def has_atleast_one_location
    # Validate only when you try to save locations and afterwards
    if account_setup_step >= Person::ACCOUNT_SETUP_STEPS[:"3"]
      if location == nil
        errors.add(:location, "need atleast one locations")
      end
    end
  end

  def has_atleast_one_skill
    # Validate only when you try to save skills and afterwards
    if account_setup_step >= Person::ACCOUNT_SETUP_STEPS[:"4"]
      if skills.empty?
        errors.add(:skills, "need atleast one skill")
      end
    end
  end

  def description_present_and_has_length
    # Validate only when you try to save skills and afterwards
    if account_setup_step >= Person::ACCOUNT_SETUP_STEPS[:"5"]
      if description == nil
        errors.add(:description, "Description cant be blank")
        return
      end

      if description.length < 50
        errors.add(:description, "Description must be bigger than 50 characters")
      end
    end
  end
end
