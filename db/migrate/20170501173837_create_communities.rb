class CreateCommunities < ActiveRecord::Migration[5.0]
  def change
    create_table :communities do |t|
      t.string :name, null: false
      t.string :home, null: false
      t.text :bio, null: false
      t.string :twitter_account
      t.string :facebook_account
      t.string :thumbnail

      t.timestamps
    end

    add_index :communities, :name, unique: true
  end
end
