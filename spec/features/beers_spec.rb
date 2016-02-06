require 'rails_helper'

include Helpers

describe "Beer" do
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when creating new beer with valid name, it is added to database" do
    visit new_beer_path
    fill_in('beer[name]', with:'kalja')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)

    save_and_open_page
  end

  it "when creating new beer with invalid name, it is not added to database" do
    visit new_beer_path
    fill_in('beer[name]', with:'')

    click_button "Create Beer"

    expect(page).to have_content 'Name can\'t be blank'
    expect(Beer.count).to eq(0)

    save_and_open_page
  end
end