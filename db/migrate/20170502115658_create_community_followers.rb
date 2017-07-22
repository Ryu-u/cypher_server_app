class CreateCommunityFollowers < ActiveRecord::Migration[5.0]
  def change
    create_table :community_followers do |t|
      t.integer :community_id, null: false
      t.integer :follower_id, null: false

      t.timestamps
    end

    add_index :community_followers, [:community_id, :follower_id], unique: true, name: 'communityfollowers_unique_index'
  end
end
