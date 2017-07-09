json.cypher do
  json.id               @cypher.id
  json.name             @cypher.name
  json.serial_num       @cypher.serial_num
  json.thumbnail_url    @cypher.community.thumbnail.url
  json.cypher_from      @cypher.cypher_from.to_s(:default)
  json.cypher_to        @cypher.cypher_to.to_s(:default)
  json.place            @cypher.place
  json.info             @cypher.info
  json.capacity         @cypher.capacity
  json.host do
    json.partial! 'v1/_user', user: @cypher.host
  end

  json.community do
    json.partial! 'v1/_community_summary', community: @cypher.community
  end
end