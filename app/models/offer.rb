# == Schema Information
#
# Table name: offers
#
#  id         :integer          not null, primary key
#  listing_id :integer
#  person_id  :string(255)
#  status     :text(65535)
#  created_at :datetime
#  updated_at :datetime
#

class Offer < ActiveRecord::Base
  STATUSES = {pending: "pending", canceled: "canceled", accepted: "accepted"}
  # TODO: We need a wraper class for business and worker
  belongs_to :business_or_worker, class_name: "Business", foreign_key: "person_id" # Eather Business or Worker
  belongs_to :listing

  validates :status, inclusion: {in: STATUSES.map{|k,s| s}}
  validates :business_or_worker, :listing, presence: true
  validate :listing_must_be_open
  validate :person_cant_create_offer_for_the_same_project

  has_one :conversation, -> { joins(:participations).where("participations.person_id = person_id").limit(1)}, :through => :listing, :source => :conversations
  before_validation :default_status

  private

  def listing_must_be_open
    return unless listing
    errors.add(:listing, "Listing must be open to receive offers.") unless listing.open
  end

  def person_cant_create_offer_for_the_same_project
    return unless listing
    errors.add(:listing, "Can't create an offer for the same project multiple times..") if Offer.where(person_id: self.person_id, listing_id: listing_id).count > 0
  end

  # MYSQL doesn't allow default values for TEXT columns.
  # So we do it on model level
  def default_status
    self.status ||= STATUSES[:pending]
  end
end
