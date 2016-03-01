class User < ActiveRecord::Base
  include RatingAverage
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, -> { distinct }, through: :memberships
  has_secure_password
  validates :username, uniqueness: true, length: { minimum: 3, maximum: 15}
  validates :password, :format => {:with => /\A(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{4,}\z/, message:
      "must be at least 4 characters and include one number and one capital letter."}

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    favorite :style
  end

  def favorite_brewery
    favorite :brewery
  end

  def favorite(category)
    return nil if ratings.empty?
    rated = ratings.map{ |r| r.beer.send(category) }.uniq
    rated.sort_by { |item| -rating_of(category, item) }.first
  end

  def rating_of(category, item)
    ratings_of = ratings.select{ |r| r.beer.send(category)==item }
    ratings_of.map(&:score).inject(&:+) / ratings_of.count.to_f
  end

  def froze_and_activate
    if self.froze
      self.update_attribute(:froze, false)
    else
      self.update_attribute(:froze, true)
    end
  end

  def most_active_users(n)
    h = User.joins(:ratings).select("users.username, rating.user_id").group(:username).count(:user_id).sort_by {|k,v| v}.reverse[0..n]
    hash = {}
    h.each do |key, value|
      u = User.find_by(:username => key)
      hash[u] = value
    end
    hash
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.id = auth["uid"]
      user.username = auth["info"]["name"]
      pass = [*('A'..'Z'),*('0'..'9')].shuffle[0,8].join
      user.password =  pass
    end
  end
end
