class CreateCommunityParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :community_participants do |t|
      t.integer :community_id, null: false
      t.integer :participant_id, null: false

      t.timestamps
    end
  end
end
