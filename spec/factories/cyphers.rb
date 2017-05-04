FactoryGirl.define do
  factory :cypher do
    name "aaaa"
    serial_num 1
    community_id 1
    info "頑張ります"
    cypher_from Date.today.to_datetime
    cypher_to Date.today.to_datetime
    place "豊中"
    host_id 1
    capacity 1
  end
end