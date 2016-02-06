class User < ActiveRecord::Base
  include RatingAverage
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, -> { distinct }, through: :memberships
  has_secure_password
  validates :username, uniqueness: true, length: { minimum: 3,
                                                   maximum: 15}
  validates :password, :format => {:with => /\A(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{4,}\z/, message:
      "must be at least 4 characters and include one number and one capital letter."}

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    h = Beer.joins(:ratings).select("beers.style, ratings.score").group(:style).average(:score)
    h.key(h.values.max)
  end

  def favorite_brewery
    return nil if ratings.empty?
    h = Brewery.joins(:ratings, :beers).select("breweries.name, ratings.score").group("breweries.name").average(:score)
    h.key(h.values.max)
  end
end
