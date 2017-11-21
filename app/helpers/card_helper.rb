module CardHelper

  def main_title object
    if object.kind_of? Business
      object.overall_name ? object.overall_name : "Business name"
    elsif object.kind_of? Worker
      object.overall_name ? object.overall_name : "Worker name"
    elsif object.kind_of? Listing
      object.title ? object.title : "Project name"
    end
  end

  def main_location object
    if object.kind_of? Business
      object.location ? object.full_location : "Business location"
    elsif object.kind_of? Worker
      object.location ? object.full_location : "My location"
    elsif object.kind_of? Listing
      object.location ? object.full_location : "Project location"
    end
  end

  def category_and_skills object
    if object.kind_of?(Business) || object.kind_of?(Worker)
      if object.skills.any?
        cat_skills = ""
        object.skills.each do |s|
          cat_skills  << "#{s.category.parent.display_name(I18n.locale)} | #{s.category.display_name(I18n.locale)}"
          cat_skills  <<  "\n" if s != object.skills.last
        end
        cat_skills
      else
        "My category | My skill"
      end
    elsif object.kind_of? Listing
    end
  end

  def main_description object 
    if object.kind_of? Business
      object.description ?  object.description : "Description of your business."
    elsif object.kind_of? Worker
      object.description ?  object.description : "Describe yourself."
    elsif object.kind_of? Listing
      object.description ?  object.description : "Describe the project."
    end
  end

  def main_image object
    if object.kind_of?(Business)
      object.image.exists? ?  object.image.url(:medium) : "/assets/default_logo.png"
    elsif object.kind_of?(Worker)
      object.image.exists? ?  object.image.url(:medium) : "/assets/default_worker.png"
    elsif object.kind_of? Listing
    end
  end

  def image_edit_url object
    if object.kind_of? Business
      business_account_setup_step1_path
    elsif object.kind_of? Worker
      worker_account_setup_step1_path
    elsif object.kind_of? Listing
      buyer_account_setup_step5_path
    end
  end

  def main_title_url object
    if object.kind_of? Business
      business_account_setup_step1_path
    elsif object.kind_of? Worker
      worker_account_setup_step1_path
    elsif object.kind_of? Listing
      buyer_account_setup_step1_path
    end
  end

  def main_location_url object
    if object.kind_of? Business
      business_account_setup_step2_path
    elsif object.kind_of? Worker
      worker_account_setup_step2_path
    elsif object.kind_of? Listing
      buyer_account_setup_step2_path
    end
  end
  def main_category_and_skills_url object
    if object.kind_of? Business
      business_account_setup_step3_path
    elsif object.kind_of? Worker
      worker_account_setup_step3_path
    elsif object.kind_of? Listing
      buyer_account_setup_step3_path
    end
  end

  def main_description_url object
    if object.kind_of? Business
      business_account_setup_step4_path
    elsif object.kind_of? Worker
      worker_account_setup_step4_path
    elsif object.kind_of? Listing
      buyer_account_setup_step4_path
    end
  end

  def main_promo_images_url object
    if object.kind_of? Business
      business_account_setup_step5_path
    elsif object.kind_of? Worker
      worker_account_setup_step5_path
    elsif object.kind_of? Listing
      buyer_account_setup_step5_path
    end
  end

  def main_price_url object
    buyer_account_setup_step5_path
  end

  def listing_price object
    return "Project price" unless object.price_cents

    if object.price_cents > 0
      price = Money.new(object.price_cents, object.currency)
      if price.currency.symbol
        humanized_money_with_symbol price
      else
        humanized_money "#{price.currency.iso_code} #{price}"
      end
    end
  end

  def project_image listing, index
    index = index ? index : 0
    listing.try(:listing_images)[index].try(:image).try(:url, :card_small)
  end

  def promo_image object, index
    index = index ? index : 0
    object.try(:images)[index].try(:image).try(:url, :card_small)
  end

end
