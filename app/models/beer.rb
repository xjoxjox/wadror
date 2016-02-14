class Beer < ActiveRecord::Base
  include RatingAverage
  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user
  validates :name, presence: true
  validate :must_have_style

  def must_have_style
    !self.style_id.nil?
  end

  def to_s
    self.name + ", " + self.brewery.name
  end
end
