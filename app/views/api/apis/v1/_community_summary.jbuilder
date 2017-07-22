json.id               community.id
json.name             community.name
json.thumbnail_url    community.thumbnail.url
json.next_cyphers do
  json.array! community.cyphers.
                        where('cypher_from >= ?', Date.today.to_datetime).
                        order(:cypher_from)  do |cypher|
    json.partial! 'v1/_cypher_summary', cypher: cypher
  end
end