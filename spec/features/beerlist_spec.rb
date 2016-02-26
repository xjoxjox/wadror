require 'rails_helper'

include Helpers


describe "Beerlist page" do

  Capybara.register_driver :selenium do |app|

    custom_profile = Selenium::WebDriver::Firefox::Profile.new

    custom_profile["network.http.prompt-temp-redirect"] = false

    Capybara::Selenium::Driver.new(:app => app, :browser => :firefox, :profile => custom_profile)
  end

  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(allow_localhost:true)
  end

  before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @brewery1 = FactoryGirl.create(:brewery, name:"Koff")
    @brewery2 = FactoryGirl.create(:brewery, name:"Schlenkerla")
    @brewery3 = FactoryGirl.create(:brewery, name:"Ayinger")
    @style1 = Style.create name:"Lager"
    @style2 = Style.create name:"Rauchbier"
    @style3 = Style.create name:"Weizen"
    @beer1 = FactoryGirl.create(:beer, name:"Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryGirl.create(:beer, name:"Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryGirl.create(:beer, name:"Lechte Weisse", brewery:@brewery3, style:@style3)
  end

  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end

  it "shows the known beers", js:true do
    visit beerlist_path
    expect(page).to have_content "Nikolai"
  end

  it "shows beers in right order", js:true do
    visit beerlist_path

    expect(find('table').find('tr:nth-child(2)')).to have_content "Fastenbier"
    expect(find('table').find('tr:nth-child(3)')).to have_content "Lechte Weisse"
    expect(find('table').find('tr:nth-child(4)')).to have_content "Nikolai"
  end

  it "shows styles in right order", js:true do
    visit beerlist_path

    click_link "style"

    expect(find('table').find('tr:nth-child(2)')).to have_content "Lager"
    expect(find('table').find('tr:nth-child(3)')).to have_content "Rauchbier"
    expect(find('table').find('tr:nth-child(4)')).to have_content "Weizen"
  end

  it "shows breweries in right order", js:true do
    visit beerlist_path

    click_link "brewery"

    expect(find('table').find('tr:nth-child(2)')).to have_content "Ayinger"
    expect(find('table').find('tr:nth-child(3)')).to have_content "Koff"
    expect(find('table').find('tr:nth-child(4)')).to have_content "Schlenkerla"
  end
end