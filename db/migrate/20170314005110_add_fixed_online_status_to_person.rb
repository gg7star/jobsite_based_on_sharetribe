class AddFixedOnlineStatusToPerson < ActiveRecord::Migration
  def change
  	add_column(:people, :fixed_online_status, 	:string, 	default: 'online')
  	add_column(:people, :last_activity_at, 		:datetime, 	default: DateTime.new(1900, 1,1))
  end
end
