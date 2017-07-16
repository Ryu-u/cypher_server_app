json.communities do
  json.array! @communities.all do |community|
    json.partial! 'v1/_community_summary', community: community
  end
end
json.total      @communities_total