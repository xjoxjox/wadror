require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "shows number of ratings at ratings page" do
    create_ratings

    visit ratings_path

    expect(page).to have_content 'Number of ratings: 3'
    expect(page).to have_content 'iso 3 10'
    expect(page).to have_content 'Karhu 20'
    expect(page).to have_content 'iso 3 20'
  end

  it "shows users ratings at users page" do
    Rating.create(score: 15, beer_id:1)
    create_ratings

    visit user_path(user)

    expect(page).to have_content 'Has made 3 ratings'
    expect(page).to have_content 'iso 3 10'
    expect(page).to have_content 'Karhu 20'
    expect(page).to have_content 'iso 3 20'
    expect(page).not_to have_content 'iso 3 15'
  end

  it "deletes users rating" do
    create_ratings

    visit user_path(user)

    page.find('li', :text => 'Karhu').click_link('delete')

    expect(user.ratings.count).to eq(2)
  end

  def create_ratings
    FactoryGirl.create :rating, beer_id:1, user_id:1
    FactoryGirl.create :rating2, beer_id:2, user_id:1
    FactoryGirl.create :rating2, beer_id:1, user_id:1
  end
end