class AddPendingToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :pending, :boolean

    Membership.all.each do |m|
      m.update_attribute :pending, false
    end
  end
end
