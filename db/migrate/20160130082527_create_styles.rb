class CreateStyles < ActiveRecord::Migration
  def change
    unless table_exists? :styles
      create_table :styles do |t|
        t.string :name
        t.text :description

        t.timestamps
      end
    end
  end
end
