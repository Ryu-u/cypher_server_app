class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :home
      t.text :bio
      t.integer :type_flag
      t.string :twitter_account
      t.string :facebook_account
      t.string :thumbnail_url

      t.timestamps
    end
  end
end
