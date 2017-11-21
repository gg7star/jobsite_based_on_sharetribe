class AccountSetup::BuyersController < ApplicationController
  include AccountSetupHelper
  include CardHelper

  before_filter do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_your_inbox")
  end

  # before_filter :validate_user_type
  before_filter :validate_current_step
  before_filter :update_buyer_account_and_setup_vars

  PROGRESSES = {
    account_setup_step: 1,
    current: 1,
    items: {
      "#{Person::ACCOUNT_SETUP_STEPS[:"1"]}": I18n.t("account_setup.buyer.steps.project_name"),
      "#{Person::ACCOUNT_SETUP_STEPS[:"2"]}": I18n.t("account_setup.buyer.steps.project_location"),
      "#{Person::ACCOUNT_SETUP_STEPS[:"3"]}": I18n.t("account_setup.buyer.steps.project_skills"),
      "#{Person::ACCOUNT_SETUP_STEPS[:"4"]}": I18n.t("account_setup.buyer.steps.project_description"),
      "#{Person::ACCOUNT_SETUP_STEPS[:"5"]}": I18n.t("account_setup.buyer.steps.project_promo_pics")
    }
  }
  
  def new_step1
    @progresses[:current] = 1
  end

  def new_step2
    @progresses[:current] = 2
    @countries = ISO3166::Country.all.sort_by!{ |c| c.name.downcase }
  end

  def new_step3
    @progresses[:current] = 3
  end

  def new_step4
    @progresses[:current] = 4
  end

  def new_step5
    @progresses[:current] = 5
  end

  def new_step6
    @title = I18n.t("account_setup.worker.step6.congratulations")
  end

  def first_listing?
    !@person.listings.any? || (@person.listings.count == 1 && Listing.listing_in_setup_progress(@person).present?)
  end


  private

  def update_buyer_account_and_setup_vars
    
    @person = @current_user#Buyer.find(@current_user)
    @listing = Listing.listing_in_setup_progress(@person) || Listing.new(author: @person, community_id: @current_community.id)
    @progresses = PROGRESSES
    @title = I18n.t("account_setup.post_a_project")
    @listing.set_account_setup_step @step_to_update_to
    @listing.open = @listing_open ? @listing_open : false;

    if request.params["_method"] == "put" && request.method == "POST"
      if !worker_or_business? && first_listing?
        @person.user_type = Buyer::PROP_NAME
        @person.account_setup_step = @step_to_update_to if @step_to_update_to > @person.account_setup_step 
        @listing.setup_step = @person.account_setup_step 
      else
        @listing.setup_step = @step_to_update_to 
      end
      
      safe_params = params.require(:listing).permit(:title, :image, :description, :valid_until, :valid_until_turnaround, :price_cents, :currency,
                                                     location_attributes: [:country, :city, :postal_code, :distance_limit, :distance_limit_unit], 
                                                     listing_images_attributes: [:id, :image, :_destroy],
                                                     listing_skills_attributes: [:id, category_id: []])

      prepare_listing_skills safe_params
      @listing.attributes = safe_params
      prepare_valid_until safe_params
      prepare_price_and_currency safe_params
      unless @listing.save
        redirect_to buyer_account_setup_step1_path, flash: {notice: "Please recheck all fields." +  @listing.errors.full_messages.to_sentence}
      end

      unless @person.save
        redirect_to buyer_account_setup_step1_path, flash: {notice: "Something went worng. " +  @person.errors.full_messages.to_sentence}
      end
    end

    @progresses[:account_setup_step] = @listing.setup_step
  end

  def validate_user_type
    if @current_user.user_type == Business::PROP_NAME || @current_user.user_type == Worker::PROP_NAME
      redirect_to homepage_index_path, flash: { warning: "This section is only accessible by (potential)buyer users." }
    end
  end

  def validate_current_step
    # No to validate first step
    # If user skips step 1 and trys to save step2(which sends data to step3) it will fail either way
    if params[:action] == "new_step2"
      @step_to_update_to = Person::ACCOUNT_SETUP_STEPS[:"2"]
    elsif params[:action] == "new_step3"
      redirect_to buyer_account_setup_step1_path if @current_user.account_setup_step < Person::ACCOUNT_SETUP_STEPS[:"2"]
      @step_to_update_to = Person::ACCOUNT_SETUP_STEPS[:"3"]
    elsif params[:action] == "new_step4"
      redirect_to buyer_account_setup_step1_path if @current_user.account_setup_step < Person::ACCOUNT_SETUP_STEPS[:"3"]
      @step_to_update_to = Person::ACCOUNT_SETUP_STEPS[:"4"]
    elsif params[:action] == "new_step5"
      redirect_to buyer_account_setup_step1_path if @current_user.account_setup_step < Person::ACCOUNT_SETUP_STEPS[:"4"]
      @step_to_update_to = Person::ACCOUNT_SETUP_STEPS[:"5"]
    elsif params[:action] == "new_step6"
      redirect_to buyer_account_setup_step1_path if @current_user.account_setup_step != Person::ACCOUNT_SETUP_STEPS[:"5"] && 
                                                      @current_user.account_setup_step != Person::ACCOUNT_SETUP_STEPS[:"6"]
      @step_to_update_to = Person::ACCOUNT_SETUP_STEPS[:"6"]
      @listing_open = true
    end
  end

  def prepare_listing_skills safe_params
    if safe_params[:listing_skills_attributes]
      # Destroy the previous records
      @listing.listing_skills.destroy_all

      safe_params[:listing_skills_attributes]["0"][:category_id].each do |c|
        if c.to_i > 0
          @listing.listing_skills << ListingSkill.new(category: Category.find(c))
        end
      end
    end
  end

  def prepare_valid_until safe_params
    if safe_params[:valid_until]
      @listing.valid_until = Time.strptime(safe_params[:valid_until], '%m/%d/%Y')
    end
  end

  def prepare_price_and_currency safe_params
    if safe_params[:price_cents] && safe_params[:currency]
      @listing.price_cents = MoneyUtil.parse_str_to_money(safe_params[:price_cents], safe_params[:currency]).cents
    end
  end
end
