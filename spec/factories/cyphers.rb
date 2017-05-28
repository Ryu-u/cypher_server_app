FactoryGirl.define do
  factory :cypher, aliases:[:participating_cyphers,
                           :hosting_cyphers] do

    community
    host

    name {Faker::Team.name}
    serial_num 1
    info {Faker::ChuckNorris.fact}
    cypher_from Date.today.to_datetime
    cypher_to Date.today.to_datetime
    place "豊中"
    host_id 1
    capacity 1
  end
end