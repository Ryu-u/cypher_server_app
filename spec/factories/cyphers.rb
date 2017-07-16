FactoryGirl.define do
  factory :cypher, aliases:[:participating_cyphers,
                           :hosting_cyphers] do

    community
    host

    name {Faker::Team.name}
    serial_num 1
    info {Faker::ChuckNorris.fact}
    cypher_from DateTime.now + 1
    cypher_to DateTime.now + 2
    place {Faker::Address.city}
    capacity 10

    trait :with_tag do
      after(:create) do |cypher|
        3.times do
          create(:cypher_tag,
                 cypher: cypher,
                 tag: create(:tag))
        end
      end
    end
  end
end