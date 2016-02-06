require 'rails_helper'

RSpec.describe Brewery, type: :model do
  it "has the name and year set correctly and is saved to database" do
    brewery = Brewery.create name:"Schlenkerla", year:1674

    brewery.should be_valid
    brewery.name { should eq("Schlenkerla") }
    brewery.year { should eq(1674) }
  end

  it "without a name is not valid" do
    brewery = Brewery.create  year:1674

    brewery.should_not be_valid
  end
end
