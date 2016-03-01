class RatingsController < ApplicationController

  def index
    Rails.cache.write("ratings", Rating.all, :expires_in => 10.minutes) unless does_cache_exist("ratings")
    @ratings = Rails.cache.read("ratings")
    Rails.cache.write("best_breweries", Brewery.first.top(Brewery, 2), :expires_in => 10.minutes) unless does_cache_exist("best_breweries")
    @top_breweries = Rails.cache.read("best_breweries_cache")
    Rails.cache.write("best_beers", Beer.first.top(Beer, 2), :expires_in => 10.minutes) unless does_cache_exist("best_beers")
    @top_beers = Rails.cache.read("best_beers_cache")
    Rails.cache.write("best_styles_cache", Style.first.top(Style, 2), :expires_in => 10.minutes) unless does_cache_exist("best_styles")
    @top_styles = Rails.cache.read("best_styles_cache")
    Rails.cache.write("active_users", User.first.most_active_users(2), :expires_in => 10.minutes) unless does_cache_exist("active_users")
    @top_raters = Rails.cache.read("active_users_cache")
    Rails.cache.write("recent", Rating.recent, :expires_in => 10.minutes) unless does_cache_exist("recent")
    @recent = Rails.cache.read("recent")
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if current_user.nil?
      redirect_to signin_path, notice:'you should be signed in'
    elsif @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end

  def does_cache_exist(cache_key)
   Rails.cache.exist?(cache_key)
  end
end