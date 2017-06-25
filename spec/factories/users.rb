require 'Faker'
FactoryGirl.define do
  factory :user, aliases:[:host, :participant, :follower] do
    name {Faker::Name.first_name}
    home {Faker::Address.city}
    bio {Faker::ChuckNorris.fact}
    type_flag 1
    twitter_account {"#{name}_tw".downcase}
    facebook_account {"#{name}_fb".downcase}
    thumbnail_url {Faker::File.file_name('path/to/',
                                        "#{name}", 'jpg')}

    trait :with_api_key do
      after(:create) do |user|
        create(:api_key, user: user)
      end
    end
  end
end