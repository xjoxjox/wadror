require File.expand_path("user.rb", "./app/models")

class AddFrozeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :froze, :boolean
    User.all.each{ |u| u.update_attribute(:froze, false) }
  end
end
