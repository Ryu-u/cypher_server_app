class CreateCommunityTags < ActiveRecord::Migration[5.0]
  def change
    create_table :community_tags do |t|
      t.integer :community_id, null: false
      t.integer :tag_id, null: false

      t.timestamps
    end

    add_index :community_tags, [:community_id, :tag_id], unique: true, name: 'communitytags_unique_index'
  end
end
