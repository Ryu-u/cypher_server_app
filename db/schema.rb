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
  end

  create_table "community_followers", force: :cascade do |t|
    t.integer  "community_id"
    t.integer  "follower_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "community_hosts", force: :cascade do |t|
    t.integer  "community_id", null: false
    t.integer  "host_id",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "community_participants", force: :cascade do |t|
    t.integer  "community_id",   null: false
    t.integer  "participant_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "community_tags", force: :cascade do |t|
    t.integer  "community_id"
    t.integer  "tag_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "cypher_participants", force: :cascade do |t|
    t.integer  "cypher_id"
    t.integer  "participant_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "cypher_tags", force: :cascade do |t|
    t.integer  "cypher_id"
    t.integer  "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cyphers", force: :cascade do |t|
    t.string   "name"
    t.integer  "serial_num"
    t.integer  "community_id"
    t.text     "info"
    t.datetime "cypher_from"
    t.datetime "cypher_to"
    t.string   "place"
    t.integer  "host_id"
    t.integer  "capacity"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "posts", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "cypher_id"
    t.string   "directory_url"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "regular_cyphers", force: :cascade do |t|
    t.integer  "community_id"
    t.text     "info"
    t.integer  "cypher_day"
    t.string   "cypher_from"
    t.string   "cypher_to"
    t.string   "place"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "content"
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
