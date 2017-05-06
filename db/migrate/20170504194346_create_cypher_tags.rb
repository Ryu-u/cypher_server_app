class CreateCypherTags < ActiveRecord::Migration[5.0]
  def change
    create_table :cypher_tags do |t|
      t.integer :cypher_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
