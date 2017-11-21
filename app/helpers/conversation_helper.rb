module ConversationHelper
	def message_receiver conversation
		conversation.participants.where('people.id != ?', @current_user.id).first
	end
end
