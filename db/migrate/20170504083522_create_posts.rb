class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.text :content
      t.integer :user_id
      t.integer :cypher_id
      t.string :directory_url

      t.timestamps
    end
  end
end
