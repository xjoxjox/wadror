require File.expand_path("beer.rb", "./app/models")
require File.expand_path("style.rb", "./app/models")

class BeerStyles < ActiveRecord::Migration
  def change
    rename_column :beers, :style, :old_style
    Beer.pluck(:old_style).uniq.each do |s|
      Style.create(:name => s, :description => "")
    end
    add_reference :beers, :style, index: true, foreign_key: true
    Beer.reset_column_information
    Beer.all.each do |b|
      b.style_id = Style.find_by(:name => b.old_style).id
      b.save!
    end
    Style.all.each do |s|
      s.beers << Beer.find_by(:style_id => s.id)
    end
    remove_column :beers, :old_style
  end
end
