class CreateCypherParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :cypher_participants do |t|
      t.integer :cypher_id, null: false
      t.integer :participant_id, null: false

      t.timestamps
    end

    add_index :cypher_participants, [:cypher_id, :participant_id], unique: true, name: 'cypherparticipants_unique_index'
  end
end
