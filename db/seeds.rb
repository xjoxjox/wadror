# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
b1 = Brewery.create name:"Koff", year:1897
b2 = Brewery.create name:"Malmgard", year:2001
b3 = Brewery.create name:"Weihenstephaner", year:1042
b4 = Brewery.create name:"BrewDog", year:2007

b1.beers.create name:"Iso 3", style:"Lager"
b1.beers.create name:"Karhu", style:"Lager"
b1.beers.create name:"Tuplahumala", style:"Lager"
b2.beers.create name:"Huvila Pale Ale", style:"Pale Ale"
b2.beers.create name:"X Porter", style:"Porter"
b3.beers.create name:"Hefeweizen", style:"Weizen"
b3.beers.create name:"Helles", style:"Lager"
b4.beers.create name:"Punk IPA", style:"IPA"
b4.beers.create name:"Nanny State", style:"lowalcohol"

Rating.create score:33, beer_id:1
Rating.create score:35, beer_id:1
Rating.create score:12, beer_id:1
Rating.create score:14, beer_id:8
Rating.create score:9, beer_id:8
Rating.create score:17, beer_id:9
Rating.create score:44, beer_id:9
Rating.create score:20, beer_id:9

u1 = User.create name:"bisse"
u3 = User.create name:"kaljaman"
u4 = User.create name:"testiuser"

d1 = BeerClub.create name:"Hyvä Pössis", founded:1980, city:"Vantaa"
d3 = BeerClub.create name:"Kaljan Kittaajat", founded:2015, city:"Tampere"
d4 = BeerClub.create name:"Kova Meininki", founded:1899, city:"Rovaniemi"