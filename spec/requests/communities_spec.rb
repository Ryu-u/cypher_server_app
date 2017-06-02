require 'rails_helper'

RSpec.describe "Communities", type: :request do
  before do
    @community = create(:community,
                        :with_host,
                        :with_participant,
                        :with_follower,
                        :with_cypher,
                        :with_regular_cypher,
                        :with_tag)

  end

  describe 'return status' do
    it 'return 200 OK' do
      get "/api/v1/communities/#{@community.id}"
      expect(response.status).to eq(200)
    end
  end

  describe 'response of community' do
    it 'matches the data-type pattern' do
      pattern = {
          community: {
              id:               Integer,
              name:             String,
              home:             String,
              bio:              String,
              twitter_account:  String,
              facebook_account: String,
              thumbnail_url:    String,
              tags: [
                  {
                      id:      Integer,
                      content: String
                  }
              ].ignore_extra_values!,
              hosts: [
                  {
                      id:                             Integer,
                      name:                           String,
                      home:                           String,
                      bio:                            String,
                      type_flag:                      Integer,
                      twitter_account:                String,
                      facebook_account:               String,
                      participating_cyphers: [
                          {
                              id:                 Integer,
                              name:               String,
                              serial_num:         Integer,
                              cypher_from:        String,
                              cypher_to:          String,
                              capacity:           Integer,
                              thumbnail_url:      String,
                          }
                      ].ignore_extra_values!,
                      participating_communities: [
                          {
                              id:                 Integer,
                              name:               String,
                              thumnail_url:       String,
                              next_cypher: [
                                  {
                                      id:                 Integer,
                                      name:               String,
                                      serial_num:         Integer,
                                      cypher_from:        String,
                                      cypher_to:          String,
                                      capacity:           Integer,
                                      thumbnail_url:      String,
                                  }
                              ].ignore_extra_values!
                          }

                      ].ignore_extra_values!,
                      thumbnail_url:                  String
                  }
              ].ignore_extra_values!,
              members: [
                  {
                      id:                             Integer,
                      name:                           String,
                      home:                           String,
                      bio:                            String,
                      type_flag:                      Integer,
                      twitter_account:                String,
                      facebook_account:               String,
                      participating_cyphers: [
                          {
                              id:                 Integer,
                              name:               String,
                              serial_num:         Integer,
                              cypher_from:        String,
                              cypher_to:          String,
                              capacity:           Integer,
                              thumbnail_url:      String,
                          }
                      ].ignore_extra_values!,
                      participating_communities: [
                          {
                              id:                 Integer,
                              name:               String,
                              thumnail_url:       String,
                              next_cypher: [
                                  {
                                      id:                 Integer,
                                      name:               String,
                                      serial_num:         Integer,
                                      cypher_from:        String,
                                      cypher_to:          String,
                                      capacity:           Integer,
                                      thumbnail_url:      String,
                                  }
                              ].ignore_extra_values!
                          }

                      ].ignore_extra_values!,
                      thumbnail_url:                  String
                  }
              ].ignore_extra_values!,
              regular_cypher: {
                      place:              String,
                      cypher_day:         Integer,
                      cypher_from:        String,
                      cypher_to:          String
              },
              past_cyphers: [
                  {
                      id:                 Integer,
                      name:               String,
                      serial_num:         Integer,
                      cypher_from:        String,
                      cypher_to:          String,
                      capacity:           Integer,
                      thumbnail_url:      String
                  }
              ].ignore_extra_values!,
              future_cyphers: [
                  {
                      id:                 Integer,
                      name:               String,
                      serial_num:         Integer,
                      cypher_from:        String,
                      cypher_to:          String,
                      capacity:           Integer,
                      thumbnail_url:      String
                  }
              ].ignore_extra_values!
          }
      }
      get "/api/v1/communities/#{@community.id}"
      expect(response.body).to match_json_expression(pattern)
    end

    #it 'matches the data-content pattern' do
    #  tags = []
    #  tags
    #  hosts =
    #  pattern = {
    #      community: {
    #          id:               @community.id,
    #          name:             @community.name,
    #          home:             @community.home,
    #          bio:              @community.bio,
    #          twitter_account:  @community.twitter_account,
    #          facebook_account: @community.facebook_account,
    #          thumbnail_url:    @community.thumbnail_url,
    #          tags:             @community.tags.all.unordered!,
    #          hosts:            @community.hosts.all.unordered!,
    #          members:          @community.participants.all.unordered!,
    #          regular_cypher:   @community.regular_cypher,
    #          past_cyphers:     @community.,
    #          future_cyphers: [
    #              {
    #                  id:                 Integer,
    #                  name:               String,
    #                  serial_num:         Integer,
    #                  cypher_from:        String,
    #                  cypher_to:          String,
    #                  capacity:           Integer,
    #                  thumbnail_url:      String
    #              }
    #          ].ignore_extra_values!
    #      }
    #  }
    #end
  end

end
