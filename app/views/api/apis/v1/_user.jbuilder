json.id                 user.id
json.name               user.name
json.home               user.home
json.bio                user.bio
json.type_flag          user.type_flag
json.twitter_account    user.twitter_account
json.facebook_account   user.facebook_account
json.google_account     user.google_account

json.participating_cyphers do
  if user.participating_cyphers.nil?
    json.null!
  else
    json.array! user.participating_cyphers.
                     where('cypher_from >= ?', Date.today.to_datetime).
                     order(:cypher_from).all  do |cypher|
      json.partial! 'v1/_cypher_summary', cypher: cypher
    end
  end
end

json.participating_communities do
  if user.participating_communities.nil?
    json.null!
  else
    json.array! user.participating_communities do |community|
      json.partial! 'v1/_community_summary', community: community
    end
  end
end

json.thumbnail_url      user.thumbnail.url