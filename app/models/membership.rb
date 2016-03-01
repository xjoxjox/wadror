class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer_club
  validates_uniqueness_of :user, :scope => :beer_club

  scope :pending, -> { where pending: [true, nil] }
  scope :confirmed, -> { where pending: false }
end
