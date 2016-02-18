class Style < ActiveRecord::Base
  include RatingAverage
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def best_style(n)
    Style.joins(:ratings, :beers).select("styles.name, ratings.score").group("styles.name").average(:score).sort_by {|k,v| v}.reverse[0..n]
  end

  def to_s
    self.name
  end
end
