class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer_club
  validate :member_of_club

  def member_of_club
    if Membership.where(user_id: self.user.id, beer_club_id: self.beer_club.id)
      errors.add(self.user.username, "already a member of this club.")
    end
  end
end
