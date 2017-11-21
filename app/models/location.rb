# == Schema Information
#
# Table name: locations
#
#  id                  :integer          not null, primary key
#  latitude            :float(24)
#  longitude           :float(24)
#  address             :string(255)
#  google_address      :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  listing_id          :integer
#  person_id           :string(255)
#  location_type       :string(255)
#  community_id        :integer
#  country             :string(255)
#  city                :string(255)
#  postal_code         :string(255)
#  distance_limit      :integer
#  distance_limit_unit :string(255)
#
# Indexes
#
#  index_locations_on_community_id  (community_id)
#  index_locations_on_listing_id    (listing_id)
#  index_locations_on_person_id     (person_id)
#

class Location < ActiveRecord::Base
  DISTANCE_UNITS = ["Km", "Miles"]
  DISTANCES = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
  

  belongs_to :person
  belongs_to :listing
  belongs_to :community

  validates :country, :city, :postal_code, :distance_limit, :distance_limit_unit, presence: true, if: :belongs_to_person
  validates :country, inclusion: { in: ISO3166::Country.all.map(&:name) }, if: :belongs_to_person
  validates :distance_limit_unit, inclusion: { in: DISTANCE_UNITS.each{ |c| c } }, if: :belongs_to_person
  validates :city, :postal_code, :distance_limit, length: {minimum: 1}, if: :belongs_to_person

  def search_and_fill_latlng(address=nil, locale=APP_CONFIG.default_locale)
    okresponse = false
    geocoder = "http://maps.googleapis.com/maps/api/geocode/json?address="

    if address == nil
      address = self.address
    end

    if address != nil && address != ""
      url = URI.escape(geocoder+address)
      resp = RestClient.get(url)
      result = JSON.parse(resp.body)

      if result["status"] == "OK"
        self.latitude = result["results"][0]["geometry"]["location"]["lat"]
        self.longitude = result["results"][0]["geometry"]["location"]["lng"]
        okresponse = true
      end
    end
    okresponse
  end

  private

  def belongs_to_person
    person != nil && listing == nil && community == nil
  end
end
