require 'Faker'
FactoryGirl.define do
  factory :community, aliases:[:hosting_community,
                              :participating_community,
                              :following_community] do

    name {Faker::Team.name}
    home {Faker::Address.city}
    bio {Faker::ChuckNorris.fact}
    facebook_account {"#{name}_fb".downcase}
    twitter_account {"#{name}_tw".downcase}
    thumbnail_url {Faker::File.file_name('path/to/',
                                        "#{name}" + '_fb', 'jpg')}

    trait :with_host do
      after(:create) do |community|
        create(:community_host,
               hosting_community: community,
               host: create(:host))
      end
    end

    trait :with_participant do
      after(:create) do |community|
        3.times do
          create(:community_participant,
                 participating_community: community,
                 participant: create(:participant))
        end
      end
    end

    trait :with_follower do
      after(:create) do |community|
        3.times do
          create(:community_follower,
                 following_community: community,
                 follower: create(:follower))
        end
      end
    end

    trait :with_cypher do
      after(:create) do |community|
        for temp in -2..2 do
          create(:cypher,
                 community: community,
                 host: create(:host),
                 cypher_from: Date.today.to_datetime + temp,
                 cypher_to: Date.today.to_datetime + temp + Rational(2,24))
        end
      end
    end

    trait :with_regular_cypher do
      after(:create) do |community|
        create(:regular_cypher, community: community)
      end
    end

    trait :with_tag do
      after(:create) do |community|
        3.times do
          create(:community_tag,
                 community: community,
                 tag: create(:tag))
        end
      end
    end

  end
end