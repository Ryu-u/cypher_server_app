json.communities do
  if @communities.nil?
    json.null!
  else
    json.array! @communities.all do |community|
      json.partial! 'v1/_community_summary', community: community
    end
  end
end