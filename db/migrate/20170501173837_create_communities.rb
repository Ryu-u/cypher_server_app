class CreateCommunities < ActiveRecord::Migration[5.0]
  def change
    create_table :communities do |t|
      t.string :name
      t.string :home
      t.text :bio
      t.string :twitter_account
      t.string :facebook_account
      t.string :thumbnail_url

      t.timestamps
    end
  end
end
