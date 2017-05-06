class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :home, null: false
      t.text :bio, null: false
      t.integer :type_flag, null: false
      t.string :twitter_account
      t.string :facebook_account
      t.string :thumbnail_url

      t.timestamps
    end
  end
end
