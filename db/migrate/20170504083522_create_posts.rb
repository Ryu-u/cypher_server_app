class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.text :content
      t.integer :user_id, null: false
      t.integer :cypher_id, null: false
      t.string :directory_url

      t.timestamps
    end

    add_index :posts, [:cypher_id, :user_id], unique: true, name: 'posts_unique_index'
  end
end
