# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170504194346) do

  create_table "communities", force: :cascade do |t|
    t.string   "name",             null: false
    t.string   "home",             null: false
    t.text     "bio",              null: false
    t.string   "twitter_account"
    t.string   "facebook_account"
    t.string   "thumbnail_url"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["name"], name: "index_communities_on_name", unique: true
  end

  create_table "community_followers", force: :cascade do |t|
    t.integer  "community_id", null: false
    t.integer  "follower_id",  null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["community_id", "follower_id"], name: "communityfollowers_unique_index", unique: true
  end

  create_table "community_hosts", force: :cascade do |t|
    t.integer  "community_id", null: false
    t.integer  "host_id",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["community_id", "host_id"], name: "communityhosts_unique_index", unique: true
  end

  create_table "community_participants", force: :cascade do |t|
    t.integer  "community_id",   null: false
    t.integer  "participant_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["community_id", "participant_id"], name: "communityparticipants_unique_index", unique: true
  end

  create_table "community_tags", force: :cascade do |t|
    t.integer  "community_id", null: false
    t.integer  "tag_id",       null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "cypher_participants", force: :cascade do |t|
    t.integer  "cypher_id",      null: false
    t.integer  "participant_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["cypher_id", "participant_id"], name: "cypherparticipants_unique_index", unique: true
  end

  create_table "cypher_tags", force: :cascade do |t|
    t.integer  "cypher_id",  null: false
    t.integer  "tag_id",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cyphers", force: :cascade do |t|
    t.string   "name",         null: false
    t.integer  "serial_num",   null: false
    t.integer  "community_id", null: false
    t.text     "info",         null: false
    t.datetime "cypher_from",  null: false
    t.datetime "cypher_to",    null: false
    t.string   "place",        null: false
    t.integer  "host_id",      null: false
    t.integer  "capacity"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "posts", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id",       null: false
    t.integer  "cypher_id",     null: false
    t.string   "directory_url"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["cypher_id", "user_id"], name: "posts_unique_index", unique: true
  end

  create_table "regular_cyphers", force: :cascade do |t|
    t.integer  "community_id", null: false
    t.text     "info",         null: false
    t.integer  "cypher_day",   null: false
    t.string   "cypher_from",  null: false
    t.string   "cypher_to",    null: false
    t.string   "place",        null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "content",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",             null: false
    t.string   "home",             null: false
    t.text     "bio",              null: false
    t.integer  "type_flag",        null: false
    t.string   "twitter_account"
    t.string   "facebook_account"
    t.string   "thumbnail_url"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

end
