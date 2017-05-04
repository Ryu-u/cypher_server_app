class CreateCommunityTags < ActiveRecord::Migration[5.0]
  def change
    create_table :community_tags do |t|
      t.integer :community_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
