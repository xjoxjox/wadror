module RatingAverage
  extend ActiveSupport::Concern
  def average_rating
    return 0 if ratings.empty?
    ratings.average(:score).round(2)
  end

  def top(x, n)
    sorted_by_rating_in_desc_order = x.all.sort_by{ |b| -(b.average_rating||0) }[0..n]
  end
end