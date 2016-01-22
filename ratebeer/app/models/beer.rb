class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def rating
    ratings.count(beer_id:self.id)
  end

  def average_rating
    @yht = 0
    ratings.where(beer_id:self.id).each do |rate|
      @yht += rate.score
    end
    @yht.to_f / self.rating
  end
end
