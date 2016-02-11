class PlacesController < ApplicationController
  def index
  end

  def show
    @key = ENV['GOOGLE_APIKEY']
  end

  def search
    if params[:city].empty?
      redirect_to places_path, notice: "City can't be empty"
    else
      @places = BeermappingApi.places_in(params[:city])
      @places.each do |place|
        session[place.id.to_s+"_name"] = place.name
        session[place.id.to_s+"_street"] = place.street
        session[place.id.to_s+"_zip"] = place.zip
        session[place.id.to_s+"_city"] = place.city
        session[place.id.to_s+"_country"] = place.country
        session[place.id.to_s+"_map"] = place.blogmap
      end
      if @places.empty?
        redirect_to places_path, notice: "No locations in #{params[:city]}"
      else
        render :index
      end
    end
  end
end