FactoryGirl.define do
  factory :regular_cypher do
    community_id 1
    info "MyText"
    cypher_day 1
    cypher_from "MyString"
    cypher_to "MyString"
    place "MyString"
  end
end
