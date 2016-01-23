module RatingAverage
  extend ActiveSupport::Concern
  def average_rating(beers)
    ratings.where(beer_id:beers.map{|beer| beer.id}).average(:score).round(2)
  end
end