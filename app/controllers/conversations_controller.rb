class ConversationsController < ApplicationController
  include MoneyRails::ActionViewExtension

  MessageForm = Form::Message

  before_filter do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_your_inbox")
  end

  def index
    # TODO select conversations regarding to worker - client mode
    conversations = @current_user.conversations
    unless conversations.any?
      flash[:notice] = "You have no conversations yet."
      redirect_to :back and return
    end
    current_conversation = conversations.first

    conversation_id = current_conversation.id
    conversation = MarketplaceService::Conversation::Query.conversation_for_person(
      conversation_id,
      @current_user.id,
      @current_community.id)

    message_form = MessageForm.new({sender_id: @current_user.id, conversation_id: conversation_id})

    conversation[:other_person] = person_entity_with_url(conversation[:other_person])

    messages = TransactionViewUtils.conversation_messages(conversation[:messages], @current_community.name_display_type)

    MarketplaceService::Conversation::Command.mark_as_read(conversation[:id], @current_user.id)

    render locals: {
      messages: messages,
      conversation_data: conversation,
      message_form: message_form,
      message_form_action: person_message_messages_path(@current_user, :message_id => conversation[:id]),
      conversations: conversations,
      current_conversation: current_conversation
    }
  end
  def show
    conversation_id = params[:id]
    conversations = @current_user.conversations
    current_conversation = conversations.find(conversation_id)

    conversation = MarketplaceService::Conversation::Query.conversation_for_person(
      conversation_id,
      @current_user.id,
      @current_community.id)

    if conversation.blank?
      flash[:error] = t("layouts.notifications.you_are_not_authorized_to_view_this_content")
      return redirect_to search_path
    end

    message_form = MessageForm.new({sender_id: @current_user.id, conversation_id: conversation_id})

    conversation[:other_person] = person_entity_with_url(conversation[:other_person])

    messages = TransactionViewUtils.conversation_messages(conversation[:messages], @current_community.name_display_type)

    MarketplaceService::Conversation::Command.mark_as_read(conversation[:id], @current_user.id)

    render template: 'conversations/index',locals: {
      messages: messages,
      conversation_data: conversation,
      message_form: message_form,
      message_form_action: person_message_messages_path(@current_user, :message_id => conversation[:id]),
      conversations: conversations,
      current_conversation: current_conversation
    }
  end

  def listings
    params[:listing_id]
  end

  def person_entity_with_url(person_entity)
    person_entity.merge({
                          url: person_path(username: person_entity[:username]),
                          display_name: PersonViewUtils.person_entity_display_name(person_entity, @current_community.name_display_type)
                        })
  end
end
