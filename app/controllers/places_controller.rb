class PlacesController < ApplicationController
  def index
  end

  def search
    if params[:city].empty?
      redirect_to places_path, notice: "City can't be empty"
    else
      @places = BeermappingApi.places_in(params[:city])
      if @places.empty?
        redirect_to places_path, notice: "No locations in #{params[:city]}"
      else
        render :index
      end
    end
  end
end