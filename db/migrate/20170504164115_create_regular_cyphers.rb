class CreateRegularCyphers < ActiveRecord::Migration[5.0]
  def change
    create_table :regular_cyphers do |t|
      t.integer :community_id
      t.text :info
      t.integer :cypher_day
      t.string :cypher_from
      t.string :cypher_to
      t.string :place

      t.timestamps
    end
  end
end
