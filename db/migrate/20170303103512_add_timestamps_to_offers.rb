class AddTimestampsToOffers < ActiveRecord::Migration
  def change
    add_column(:offers, :created_at, :datetime)
    add_column(:offers, :updated_at, :datetime)
  end
end
