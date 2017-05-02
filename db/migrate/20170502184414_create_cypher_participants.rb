class CreateCypherParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :cypher_participants do |t|
      t.integer :cypher_id
      t.integer :participant_id

      t.timestamps
    end
  end
end
