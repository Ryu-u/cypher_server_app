require 'rails_helper'

describe Post do
  describe 'with DB' do
      it {have_not_null_constraint_on(:user_id)}
      it {have_not_null_constraint_on(:cypher_id)}

    describe 'of index' do
      it 'should not have two records whith have the same combination of cypher_id and user_id' do
        expect do
          community = Community.create(name: "aaaa", home: "aaaa", bio: "aaaa")
          host = User.create(name: "aaaa", home: "aaaa", bio: "aaaa", type_flag:1)
          community.hosts << host
          community.save
          cypher = Cypher.new(name: "aaaa",
                              serial_num:1,
                              info:"aaaa",
                              cypher_from:DateTime.now(),
                              cypher_to:DateTime.now(),
                              place:"aaaa")
          cypher.community = community
          cypher.host = host
          cypher.save

          post = Post.new
          poster = User.create(name: "bbbb", home: "bbbb", bio: "bbbb", type_flag:1)
          post.cypher = cypher
          post.user = poster
          post.save

          another_post = Post.new(cypher_id: cypher.id, user_id: poster.id)
          another_post.save!(validate: false)
        end.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe 'with model' do
    describe 'association' do
      it {is_expected.to belong_to(:cypher)}
      it {is_expected.to belong_to(:user)}
    end

    describe 'validation' do
      it { is_expected.to validate_presence_of(:cypher_id) }
      it { is_expected.to validate_presence_of(:user_id) }

      describe 'of uniqueness' do
        subject{Post.new(cypher_id:1, user_id:1)}
        it { is_expected.to validate_uniqueness_of(:cypher_id).scoped_to(:user_id) }
      end
    end
  end
end
