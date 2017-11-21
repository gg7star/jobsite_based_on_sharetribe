class CreateTableOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.belongs_to :listing
      t.string :person_id # person_id is a string, we do it manually
      t.text :status
    end
  end
end
