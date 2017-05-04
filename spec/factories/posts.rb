FactoryGirl.define do
  factory :post do
    content "MyText"
    user_id 1
    cypher_id 1
    directory_url "MyString"
  end
end
