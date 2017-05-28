require 'Faker'
require 'tod'
FactoryGirl.define do
  factory :regular_cypher do
    community

    info {Faker::ChuckNorris.fact}
    cypher_day 1
    cypher_from Tod::TimeOfDay.parse("18").to_s
    cypher_to Tod::TimeOfDay.parse("21").to_s
    place {Faker::Address.city}
  end
end
