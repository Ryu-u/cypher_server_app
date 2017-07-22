require 'Faker'
FactoryGirl.define do
  factory :api_key do

    user

    firebase_uid {Faker::Vehicle.vin}

  end
end
