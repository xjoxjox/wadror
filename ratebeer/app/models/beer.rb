class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def rating
    ratings.count(beer_id:self.id)
  end

  def average_rating
    ratings.where(beer_id:self.id).average(:score).round(2)
  end

  def to_s
    self.name + ", " + self.brewery.name
  end
end
