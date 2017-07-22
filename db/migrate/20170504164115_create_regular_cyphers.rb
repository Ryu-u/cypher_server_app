class CreateRegularCyphers < ActiveRecord::Migration[5.0]
  def change
    create_table :regular_cyphers do |t|
      t.integer :community_id, null: false
      t.text :info, null: false
      t.integer :cypher_day, null: false
      t.string :cypher_from, null: false
      t.string :cypher_to, null: false
      t.string :place, null: false

      t.timestamps
    end

    add_index :regular_cyphers, :community_id, unique: true, name: "regularcyphers_unique_index"
  end
end
