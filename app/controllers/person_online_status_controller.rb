class PersonOnlineStatusController < ApplicationController
	before_filter do |controller|
    	controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_your_inbox")
  	end

  	STATIC_ONLINE_STATUS = ["online", "offline", "away", "brb"]

  	def set_static
  		if STATIC_ONLINE_STATUS.include? params[:status]
  			@current_user.fixed_online_status  = params[:status]
  			@current_user.save!
  		end
  		head :no_content
  	end

end