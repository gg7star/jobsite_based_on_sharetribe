module AccountSetupHelper

  def progress_bar_item_state_class progresses, current_progress
    state_classes = ""
    
    # If we have already finished this step, then give complete class
    if progresses[:account_setup_step].to_s.to_i > current_progress.to_s.to_i
      state_classes = "complete"
    else
      # If we are currently editing this step, give active status
      if progresses[:current] == current_progress.to_s.to_i
        state_classes = "incomplete active"
      else
        state_classes = "incomplete"
      end
    end

    state_classes
  end

  def bottom_progress_bar_item_state_class progresses, current_progress
    state_classes = ""
    
    # If we are currently editing this step, give active status
    if progresses[:current] == current_progress.to_s.to_i
      state_classes = "active"
    end

    state_classes
  end

  def progress_bar_step_link key, person
    if person.kind_of? Business
      send("business_account_setup_step#{key.to_s.to_i}_path".to_sym)
    elsif person.kind_of? Worker
      send("worker_account_setup_step#{key.to_s.to_i}_path".to_sym)
    else
      send("buyer_account_setup_step#{key.to_s.to_i}_path".to_sym)
    end
  end

  def options_for_buyer_skill_select selected_category
      Category.where(parent_id: selected_category)
  end

  def turnaround_options_list
    [
      ['Urgent', 1],
      ['Flexible', 2],
      ['Cheapest turnaround available', 3],
      ['Not important', 4]
    ]
  end

  def current_parent_category listing
    if listing.listing_skills.any?
      listing.listing_skills.first.category.try(:parent_id)
    end
  end
end
