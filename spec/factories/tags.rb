require 'Faker'
FactoryGirl.define do
  factory :tag do

    content {Faker::Zelda.unique.character}
  end
end
