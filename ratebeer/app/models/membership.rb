class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer_club
  validates_uniqueness_of :user, :scope => :beer_club
end
