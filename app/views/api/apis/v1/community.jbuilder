require 'date'
json.community do
  json.id               @community.id
  json.name             @community.name
  json.home             @community.home
  json.bio              @community.bio
  json.twitter_account  @community.twitter_account
  json.facebook_account @community.facebook_account
  json.thumbnail_url    @community.thumbnail.url

  json.tags do
   if @community.tags.nil?
     json.null!
   else
     json.array! @community.tags.all do |tag|
       json.partial! 'v1/_tag', tag: tag
     end
   end
  end

  json.hosts do
    json.array! @community.hosts.all do |host|
      json.partial! 'v1/_user', user: host
    end
  end

  json.members do
    if @community.participants.nil?
      json.null!
    else
      json.array! @community.participants.all do |participant|
        json.partial! 'v1/_user', user: participant
      end
    end
  end

  json.regular_cypher do
    if @community.regular_cypher.nil?
      json.null!
    else
      json.place               @community.regular_cypher.place
      json.cypher_day          @community.regular_cypher.cypher_day
      json.cypher_from         @community.regular_cypher.cypher_from
      json.cypher_to           @community.regular_cypher.cypher_to
    end
  end

  if @past_cyphers.nil?
    json.null!
  else
    json.past_cyphers do
      json.array! @past_cyphers do |cypher|
        json.partial! 'v1/_cypher_summary', cypher: cypher
      end
    end
  end

  if @future_cyphers.nil?
    json.null!
  else
    json.future_cyphers do
      json.array! @future_cyphers do |cypher|
        json.partial! 'v1/_cypher_summary', cypher: cypher
      end
    end
  end
end