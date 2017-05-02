class CreateCyphers < ActiveRecord::Migration[5.0]
  def change
    create_table :cyphers do |t|
      t.string :name
      t.integer :serial_num
      t.integer :community_id
      t.text :info
      t.datetime :cypher_from
      t.datetime :cypher_to
      t.string :place
      t.integer :host_id
      t.integer :capacity

      t.timestamps
    end
  end
end
