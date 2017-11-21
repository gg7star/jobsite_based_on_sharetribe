class OffersController < ApplicationController
  before_filter do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_this_content")
  end

  # before_filter :ensure_is_worker_or_buyer
  before_action :fetch_listing, :fetch_recipient, :only => [:create]

  def create
    if post_params[:listing_id]
      # TODO: THIS IS NEEDS TO BE FIXED ON MONDAY!
      offer = Offer.new(listing: @listing, business_or_worker: Business.find(@current_user))

      # for offer
      @redirect_path = listings_path
      @notice_messasge = "Offer created successfully!"
      if offer.save
        # moved from person_message_controller.rb 

        # TODO: change sender_id to worker/business when it's invite - this is for offer
        create_conversation

        #
      else
        redirect_to @redirect_path, flash: {notice: "Can't save offer"}
      end
    else
      redirect_to @redirect_path, flash: {notice: "listing_id is mandatory"}
    end
  end

  def accept
    offer = Offer.find(params[:id])
    offer.status = Offer::STATUSES[:accepted]
    offer.save

    redirect_to conversation_path(id: offer.conversation.id)
  end
  private

  def fetch_listing
      @listing = Listing.find(params[:listing_id])
  end

  def fetch_recipient
    username = post_params[:person_id]
    @recipient = Person.find_by!(username: username, community_id: @current_community.id)
    if @current_user == @recipient
      flash[:error] = t("layouts.notifications.you_cannot_send_message_to_yourself")
      redirect_to search_path
    end
  end

  def create_conversation
    validate(post_params).and_then { |post_params|
      save_conversation(post_params)
    }.on_success { |conversation|
      flash[:notice] = @notice_messasge
      Delayed::Job.enqueue(MessageSentJob.new(conversation.messages.last.id, @current_community.id))
      #TODO redirect to conversations_path(conversation_id: 1)
      redirect_to conversation_path(id: conversation.id)
    }.on_error {
      flash[:error] = t("layouts.notifications.message_not_sent")
      redirect_to @redirect_path
    }
  end


  def validate(post_params)
    content_present = Maybe(post_params)[:conversation][:message_attributes][:content]
                      .map(&:present?)
                      .or_else(false)

    if content_present
      Result::Success.new(post_params)
    else
      Result::Error.new("Message content was empty")
    end
  end

  def save_conversation(post_params)
    conversation = new_conversation(post_params)
    if conversation.save
      Result::Success.new(conversation)
    else
      Result::Error.new("Message saving failed")
    end
  end

  def new_conversation(post_params)
    conversation_params = post_params.require(:conversation).permit(
      message_attributes: :content
    )
    conversation_params[:message_attributes][:sender_id] = @current_user.id
    conversation = Conversation.new(conversation_params.merge(community: @current_community, listing_id: post_params[:listing_id]))
    conversation.build_starter_participation(@current_user)
    conversation.build_participation(@recipient)
    conversation
  end

  def post_params
    params.merge({conversation: {message_attributes: {content: "Hello! Let's talk!"}}})
  end
end
