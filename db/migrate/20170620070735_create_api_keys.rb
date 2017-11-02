class CreateApiKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :api_keys do |t|
      t.integer :user_id    , null: false
      t.string :access_token, null: false
      t.string :twitter_uid, null: false
      t.datetime :expires_at

      t.timestamps
    end
    add_index :api_keys, ["user_id"], name: "index_api_keys_on_user_id", unique: true
    add_index :api_keys, ["access_token"], name: "index_api_keys_on_access_token", unique: true
    add_index :api_keys, ["twitter_uid"], name: "index_api_keys_on_twitter_uid", unique: true
  end
end
