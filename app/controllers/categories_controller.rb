class CategoriesController < ApplicationController
  def index
    @categories = fetch_categories params
    @listing    = Listing.find(params[:listing_id]) if params[:listing_id]
    respond_to do |format|
      format.html {render text: "Not available."}
      format.js   {render :layout => false, locals: {selected_category: params[:id]}}
      format.json { render :json => @categories.map{|c| {id: c.id, display_name: c.display_name(I18n.locale)} }.to_json }
    end
  end

  private

  def fetch_categories params
    if params[:id]
      Category.where(parent_id: params[:id])
    else
      @current_community.top_level_categories
    end
  end
end
