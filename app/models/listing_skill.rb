# == Schema Information
#
# Table name: categories_listings
#
#  id          :integer          not null, primary key
#  category_id :integer
#  listing_id  :integer
#

class ListingSkill < ActiveRecord::Base
  self.table_name = "categories_listings"

  belongs_to :category
  belongs_to :listing
end
