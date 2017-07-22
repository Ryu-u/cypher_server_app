json.cyphers do
  json.array! @cyphers.all do |cypher|
    json.partial! 'v1/_cypher_summary', cypher: cypher
  end
end
json.total @cyphers_total
