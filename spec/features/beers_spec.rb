require 'rails_helper'

include Helpers

describe "Beer" do
  let!(:user) { FactoryGirl.create :user }
  let!(:style) { FactoryGirl.create :style, name:"Lager" }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when creating new beer with valid name, it is added to database" do
    visit new_beer_path
    fill_in('beer[name]', with:'kalja')
    select("Lager", from:'beer[style_id]')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "when creating new beer with invalid name, it is not added to database" do
    visit new_beer_path
    fill_in('beer[name]', with:'')
    select("Lager", from:'beer[style_id]')

    click_button "Create Beer"

    expect(page).to have_content 'Name can\'t be blank'
    expect(Beer.count).to eq(0)
  end
end