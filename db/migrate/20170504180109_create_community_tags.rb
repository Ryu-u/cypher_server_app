class CreateCommunityTags < ActiveRecord::Migration[5.0]
  def change
    create_table :community_tags do |t|
      t.integer :community_id, null: false
      t.integer :tag_id, null: false

      t.timestamps
    end
  end
end
