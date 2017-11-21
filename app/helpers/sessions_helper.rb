module SessionsHelper
	def worker_dashboard_mode?
		session[:dashboard_mode]&.intern != :buyer
	end
	def worker_or_business?
		['worker', 'business'].include? @current_user&.user_type
	end
	def worker?
		@current_user&.user_type == 'worker'
	end
	def business?
		@current_user&.user_type == 'business'
	end
	def buyer?
		@current_user&.user_type == 'buyer'
	end
end
