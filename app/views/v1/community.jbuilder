require 'date'
json.community do
  json.id               @community.id
  json.name             @community.name
  json.home             @community.home
  json.bio              @community.bio
  json.twitter_account  @community.twitter_account
  json.facebook_account @community.facebook_account
  json.thumbnail_url    @community.thumbnail_url

  json.tags do
    json.array! @community.tags.all do |tag|
      json.partial! 'v1/_tag'
    end
  end
  
  json.hosts do
    json.array! @community.hosts.all do |host|
      json.partial! 'v1/_user', user: host
    end
  end

  json.members do
    json.array! @community.participants.all do |participant|
      json.partial! 'v1/_user', user: participant
    end
  end

  json.regular_cypher do
    json.info           @community.regular_cypher.info
    json.cypher_day     @community.regular_cypher.cypher_day
    json.cypher_from    @community.regular_cypher.cypher_from
    json.cypher_to      @community.regular_cypher.cypher_to
    json.place          @community.regular_cypher.place
  end

  json.past_cyphers do
    json.array! @community.cyphers.
                            where('cypher_from < ?', Date.today.to_datetime).
                              order(cypher_from: :desc).all do |cypher|
      json.partial! 'v1/_cypher_summary', cypher: cypher
    end
  end

  json.future_cyphers do
    json.array! @community.cyphers.
                            where('cypher_from >= ?', Date.today.to_datetime).
                              order(:cypher_from).all  do |cypher|
      json.partial! 'v1/_cypher_summary', cypher: cypher
    end
  end
end