require File.expand_path("user.rb", "./app/models")

class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean
    User.all.each{ |u| u.update_attribute(:admin, false) }
    u = User.first
    if u
      User.first.update_attribute(:admin, true)
    end
  end
end