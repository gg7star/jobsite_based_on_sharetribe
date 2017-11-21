# == Schema Information
#
# Table name: categories_people
#
#  id                  :integer          not null, primary key
#  category_id         :integer
#  person_id           :string(255)
#  years_of_experience :integer
#

class Skill < ActiveRecord::Base
  self.table_name = "categories_people"
  YEARS = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]

  belongs_to :category
  belongs_to :person
end
