class CreateCommunityParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :community_participants do |t|
      t.integer :community_id, null: false
      t.integer :participant_id, null: false

      t.timestamps
    end

    add_index :community_participants, [:community_id, :participant_id], unique: true, name: 'communityparticipants_unique_index'
  end
end
