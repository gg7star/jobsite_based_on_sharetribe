# encoding: utf-8
# == Schema Information
#
# Table name: listings
#
#  id                              :integer          not null, primary key
#  uuid                            :binary(16)       not null
#  community_id                    :integer          not null
#  author_id                       :string(255)
#  category_old                    :string(255)
#  title                           :string(255)
#  times_viewed                    :integer          default(0)
#  language                        :string(255)
#  created_at                      :datetime
#  updates_email_at                :datetime
#  updated_at                      :datetime
#  last_modified                   :datetime
#  sort_date                       :datetime
#  listing_type_old                :string(255)
#  description                     :text(65535)
#  origin                          :string(255)
#  destination                     :string(255)
#  valid_until                     :datetime
#  delta                           :boolean          default(TRUE), not null
#  open                            :boolean          default(TRUE)
#  share_type_old                  :string(255)
#  privacy                         :string(255)      default("private")
#  comments_count                  :integer          default(0)
#  subcategory_old                 :string(255)
#  old_category_id                 :integer
#  category_id                     :integer
#  share_type_id                   :integer
#  listing_shape_id                :integer
#  transaction_process_id          :integer
#  shape_name_tr_key               :string(255)
#  action_button_tr_key            :string(255)
#  price_cents                     :integer
#  currency                        :string(255)
#  quantity                        :string(255)
#  unit_type                       :string(32)
#  quantity_selector               :string(32)
#  unit_tr_key                     :string(64)
#  unit_selector_tr_key            :string(64)
#  deleted                         :boolean          default(FALSE)
#  require_shipping_address        :boolean          default(FALSE)
#  pickup_enabled                  :boolean          default(FALSE)
#  shipping_price_cents            :integer
#  shipping_price_additional_cents :integer
#  availability                    :string(32)       default("none")
#  setup_step                      :integer          default(1)
#  valid_until_turnaround          :integer
#
# Indexes
#
#  homepage_query                      (community_id,open,sort_date,deleted)
#  homepage_query_valid_until          (community_id,open,valid_until,sort_date,deleted)
#  index_listings_on_category_id       (old_category_id)
#  index_listings_on_community_id      (community_id)
#  index_listings_on_listing_shape_id  (listing_shape_id)
#  index_listings_on_new_category_id   (category_id)
#  index_listings_on_open              (open)
#  index_listings_on_uuid              (uuid) UNIQUE
#  person_listings                     (community_id,author_id)
#  updates_email_listings              (community_id,open,updates_email_at)
#

class Listing < ActiveRecord::Base

  include ApplicationHelper
  include ActionView::Helpers::TranslationHelper
  include Rails.application.routes.url_helpers

  belongs_to :author, :class_name => "Person", :foreign_key => "author_id"

  has_many :listing_images, -> { where("error IS NULL") }, :dependent => :destroy

  has_many :conversations
  has_many :comments, :dependent => :destroy
  has_many :custom_field_values, :dependent => :destroy
  has_many :custom_dropdown_field_values, :class_name => "DropdownFieldValue"
  has_many :custom_checkbox_field_values, :class_name => "CheckboxFieldValue"
  has_many :offers, :dependent => :destroy

  has_one :location, :dependent => :destroy
  has_one :origin_loc, -> { where('location_type = ?', 'origin_loc') }, :class_name => "Location", :dependent => :destroy
  has_one :destination_loc, -> { where('location_type = ?', 'destination_loc') }, :class_name => "Location", :dependent => :destroy
  has_many :listing_skills, class_name: "ListingSkill"
  accepts_nested_attributes_for :origin_loc, :destination_loc, :location, :listing_skills
  accepts_nested_attributes_for :listing_images, allow_destroy: true


  has_and_belongs_to_many :followers, :class_name => "Person", :join_table => "listing_followers"

  monetize :price_cents, :allow_nil => true, with_model_currency: :currency
  monetize :shipping_price_cents, allow_nil: true, with_model_currency: :currency
  monetize :shipping_price_additional_cents, allow_nil: true, with_model_currency: :currency

  before_validation :set_valid_until_time

  validates_presence_of :author_id
  validates_length_of :title, :in => 2..60, :allow_nil => false

  before_create :set_sort_date_to_now
  def set_sort_date_to_now
    self.sort_date ||= Time.now
  end

  before_create :set_updates_email_at_to_now
  def set_updates_email_at_to_now
    self.updates_email_at ||= Time.now
  end

  def uuid_object
    if self[:uuid].nil?
      nil
    else
      UUIDUtils.parse_raw(self[:uuid])
    end
  end

  def uuid_object=(uuid)
    self.uuid = UUIDUtils.raw(uuid)
  end

  before_create :add_uuid
  def add_uuid
    self.uuid ||= UUIDUtils.create_raw
  end

  @account_setup_step = Person::ACCOUNT_SETUP_STEPS[:"6"] # By default all validation should be enabled
  def set_account_setup_step step
    @account_setup_step = step
  end

  before_validation do
    # Normalize browser line-breaks.
    # Reason: Some browsers send line-break as \r\n which counts for 2 characters making the
    # 5000 character max length validation to fail.
    # This could be more general helper function, if this is needed in other textareas.
    self.description = description.gsub("\r\n","\n") if self.description
  end
  validates :description, length: {:maximum => 5000}, :allow_nil => true, if: lambda { |l| @account_setup_step >= Person::ACCOUNT_SETUP_STEPS[:"5"] }
  validates_presence_of :listing_skills, if: lambda { |l| @account_setup_step >= Person::ACCOUNT_SETUP_STEPS[:"4"] }
  validates_presence_of :location, if: lambda { |l| @account_setup_step >= Person::ACCOUNT_SETUP_STEPS[:"3"] }
  validates_inclusion_of :valid_until, :allow_nil => :true, :in => DateTime.now..DateTime.now + 7.months, 
    if: lambda { |l| @account_setup_step >= Person::ACCOUNT_SETUP_STEPS[:"5"] }
  validates_numericality_of :price_cents, :only_integer => true, :greater_than_or_equal_to => 0, :message => "price must be numeric", :allow_nil => true,
    if: lambda { @account_setup_step >= Person::ACCOUNT_SETUP_STEPS[:"5"] }


  def self.listing_in_setup_progress(person) 
    where("listings.author_id = ? AND setup_step != 6", person.id)&.first
  end
  def self.currently_open(status="open")
    status = "open" if status.blank?
    case status
    when "all"
      where([])
    when "open"
      where(["open = '1' AND (valid_until IS NULL OR valid_until > ?)", DateTime.now])
    when "closed"
      where(["open = '0' OR (valid_until IS NOT NULL AND valid_until < ?)", DateTime.now])
    end
  end

  def visible_to?(current_user, current_community)
    ListingVisibilityGuard.new(self, current_community, current_user).visible?
  end

  # sets the time to midnight
  def set_valid_until_time
    #Added by Joe
    #parse Valid_until_turnaround to valid_until
    self.valid_until = valid_until_date_parser(self.valid_until_turnaround) if self.valid_until_turnaround
    ##
    if valid_until
      self.valid_until = valid_until.utc + (23-valid_until.hour).hours + (59-valid_until.min).minutes + (59-valid_until.sec).seconds
    end
  end
  
  def posted_days_ago
    (Date.current - self.created_at.to_date).to_i
  end

  def full_location
    "#{self.location.try(:country)}, #{self.location.try(:city)}, #{self.location.try(:postal_code)}"
  end

  # Overrides the to_param method to implement clean URLs
  def to_param
    self.class.to_param(id, title)
  end

  def self.to_param(id, title)
    "#{id}-#{title.to_url}"
  end

  def self.find_by_category_and_subcategory(category)
    Listing.where(:category_id => category.own_and_subcategory_ids)
  end

  # Returns true if listing exists and valid_until is set
  def temporary?
    !new_record? && valid_until
  end

  def update_fields(params)
    update_attribute(:valid_until, nil) unless params[:valid_until]
    update_attributes(params)
  end

  def closed?
    !open? || (valid_until && valid_until < DateTime.now)
  end

  # Send notifications to the users following this listing
  # when the listing is updated (update=true) or a
  # new comment to the listing is created.
  def notify_followers(community, current_user, update)
    followers.each do |follower|
      unless follower.id == current_user.id
        if update
          MailCarrier.deliver_now(PersonMailer.new_update_to_followed_listing_notification(self, follower, community))
        else
          MailCarrier.deliver_now(PersonMailer.new_comment_to_followed_listing_notification(comments.last, follower, community))
        end
      end
    end
  end

  def image_by_id(id)
    listing_images.find_by_id(id)
  end

  def prev_and_next_image_ids_by_id(id)
    listing_image_ids = listing_images.collect(&:id)
    ArrayUtils.next_and_prev(listing_image_ids, id);
  end

  def has_image?
    !listing_images.empty?
  end

  def icon_name
    category.icon_name
  end

  # The price symbol based on this listing's price or community default, if no price set
  def price_symbol
    price ? price.symbol : MoneyRails.default_currency.symbol
  end

  def answer_for(custom_field)
    custom_field_values.find { |value| value.custom_field_id == custom_field.id }
  end

  def unit_type
    Maybe(read_attribute(:unit_type)).to_sym.or_else(nil)
  end

  def valid_until_date_parser valid_until_turnaround
    Time.now + valid_until_turnaround * valid_until_turnaround * 5.days
  end
end