# coding: utf-8

com1 = Community.create(name: 'pushers', home: 'toyoda', bio: 'just do it', twitter_account: 'psr_com', facebook_account: 'psr_com', thumbnail_url: 'aaaa')
com2 = Community.create(name: 'dealers', home: 'sendai', bio: 'asap', twitter_account: 'dlr_com', facebook_account: 'dlr_com', thumbnail_url: 'bbbb')

user1 = User.create(name:'pusher', home:'toyonaka', bio:'just do it', type_flag:'1', twitter_account:'pusher', facebook_account:'pusher')
user2 = User.create(name:'dealer', home:'sendai', bio:'asap', type_flag:'1', twitter_account:'dealer', facebook_account:'dealer')
user3 = User.create(name:'pusher-a', home:'toyonaka', bio:'just do it', type_flag:'1', twitter_account:'pusher-a', facebook_account:'pusher-a')
user4 = User.create(name:'pusher-b', home:'toyonaka', bio:'just do it', type_flag:'1', twitter_account:'pusher-b', facebook_account:'pusher-b')
user5 = User.create(name:'pusher-c', home:'toyonaka', bio:'just do it', type_flag:'1', twitter_account:'pusher-c', facebook_account:'pusher-c')

com1.hosts << user1

com1.participants << user3
com1.participants << user4
com1.participants << user5

cy10 = Cypher.new(name: 'pushers', serial_num: 5,  info: 'sellin', cypher_from: (Date.today + 2).to_datetime, cypher_to: (Date.today + 2).to_datetime + Rational(2,24), place: 'toyonaka',  capacity: 10)
cy9	 = Cypher.new(name: 'pushers', serial_num: 4,  info: 'sellin', cypher_from: (Date.today + 1).to_datetime, cypher_to: (Date.today + 1).to_datetime + Rational(2,24), place: 'toyonaka',  capacity: 10)
cy8	 = Cypher.new(name: 'pushers', serial_num: 3,  info: 'sellin', cypher_from: (Date.today ).to_datetime, cypher_to: (Date.today).to_datetime + Rational(2,24), place: 'toyonaka',         capacity: 10)
cy7	 = Cypher.new(name: 'pushers', serial_num: 2,  info: 'sellin', cypher_from: (Date.today - 1).to_datetime, cypher_to: (Date.today - 1).to_datetime + Rational(2,24), place: 'toyonaka',  capacity: 10)
cy6	 = Cypher.new(name: 'pushers', serial_num: 1,  info: 'sellin', cypher_from: (Date.today - 2).to_datetime, cypher_to: (Date.today - 2).to_datetime + Rational(2,24), place: 'toyonaka',  capacity: 10)

cy5 = Cypher.new(name: 'dealers', serial_num: 5,  info: 'sellin', cypher_from: (Date.today + 2).to_datetime, cypher_to: (Date.today + 2).to_datetime + Rational(2,24), place: 'sendai',  capacity: 10)
cy4 = Cypher.new(name: 'dealers', serial_num: 4,  info: 'sellin', cypher_from: (Date.today + 1).to_datetime, cypher_to: (Date.today + 1).to_datetime + Rational(2,24), place: 'sendai',  capacity: 10)
cy3 = Cypher.new(name: 'dealers', serial_num: 3,  info: 'sellin', cypher_from: (Date.today ).to_datetime, cypher_to: (Date.today).to_datetime + Rational(2,24), place: 'sendai',         capacity: 10)
cy2 = Cypher.new(name: 'dealers', serial_num: 2,  info: 'sellin', cypher_from: (Date.today - 1).to_datetime, cypher_to: (Date.today - 1).to_datetime + Rational(2,24), place: 'sendai',  capacity: 10)
cy1 = Cypher.new(name: 'dealers', serial_num: 1,  info: 'sellin', cypher_from: (Date.today - 2).to_datetime, cypher_to: (Date.today - 2).to_datetime + Rational(2,24), place: 'sendai',  capacity: 10)

com1.cyphers << cy10
com1.cyphers << cy9
com1.cyphers << cy8
com1.cyphers << cy7
com1.cyphers << cy6
com2.cyphers << cy5
com2.cyphers << cy4
com2.cyphers << cy3
com2.cyphers << cy2
com2.cyphers << cy1

cy10.host = user1
cy9.host = user1
cy8.host = user1
cy7.host = user1
cy6.host = user1
cy5.host = user2
cy4.host = user2
cy3.host = user2
cy2.host = user2
cy1.host = user2

cy10.save
cy9.save
cy8.save
cy7.save
cy6.save
cy5.save
cy4.save
cy3.save
cy2.save
cy1.save

cy10.participants << user3
cy10.participants << user4
cy10.participants << user5
cy9.participants << user3
cy9.participants << user4
cy9.participants << user5
cy8.participants << user3
cy8.participants << user4
cy8.participants << user5
cy7.participants << user3
cy7.participants << user4
cy7.participants << user5
cy6.participants << user3
cy6.participants << user4
cy6.participants << user5

com1_regular_cypher = RegularCypher.new(info: 'aaa', cypher_day:1, cypher_from:'19:00:00', cypher_to:'22:00:00', place:'hitachinaka')
com1.regular_cypher = com1_regular_cypher
com1_regular_cypher.save

tag1 = Tag.create(content:'for beginer')
tag2 = Tag.create(content:'skill up')

com1.tags << tag1
com1.tags << tag2

tag1.save
tag2.save