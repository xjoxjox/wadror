require 'rails_helper'

RSpec.describe Beer, type: :model do

  it "is saved if name and style are set" do
    sty = Style.create name:"Lager"
    beer = Beer.create name:"Pintti", style_id:sty.id

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without name" do
    sty = Style.create name:"Lager"
    beer = Beer.create style_id:sty.id

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without style" do
    beer = Beer.create name:"Pintti"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
