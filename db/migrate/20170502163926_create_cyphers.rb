class CreateCyphers < ActiveRecord::Migration[5.0]
  def change
    create_table :cyphers do |t|
      t.string :name, null: false
      t.integer :serial_num, null: false
      t.integer :community_id, null: false
      t.text :info, null: false
      t.datetime :cypher_from, null: false
      t.datetime :cypher_to, null: false
      t.string :place, null: false
      t.integer :host_id, null: false
      t.integer :capacity

      t.timestamps
    end
  end
end
