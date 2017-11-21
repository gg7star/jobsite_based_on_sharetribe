module MarketplaceService
	class OnlineStatus
		include Rails.application.routes.url_helpers
		include ActionView::Helpers::AssetUrlHelper
		include ActionView::Helpers::TranslationHelper
		include ApplicationHelper

		attr_accessor :user
		def initialize user
			raise InvalidUser unless  user
			@user = user
		end
		class InvalidUser < StandardError
		end

		

		def check_user_status user
			last_seen_at = user.last_seen_at
			status = 'offline'
			case Time.now - last_seen_at 
			when 0.hour..10.hours
				status = 'online'
			else
				status = 'offline'
			end
			return status
		end

		def getStatusList
			# TODO  check if hired or not hired 
			# 		currnetly only check for conversations
			@user.conversations.each_with_object([]) do |c, a|
				other_party = c.other_party(@user)

				a << {
					last_connected: 	time_ago(c.last_message_at),
				 	name: 	other_party.full_name,
				 	project_title:  	c.listing.title,
				 	project_url:    	listing_path(id: c.listing.id),
				 	last_message: 		c.last_message.content[0..30],
				 	message_url: 		conversation_path(id: c.id),
				 	avatar_url: 		other_party.image.present? ? other_party.image.url(:thumb) : "/assets/profile_image/thumb/missing.png"
				} if check_user_status(other_party) == 'online'
			end
		end
	end
end