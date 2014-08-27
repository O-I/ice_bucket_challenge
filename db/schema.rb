# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140827185037) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bucketeers", force: true do |t|
    t.string   "name"
    t.string   "identifier"
    t.text     "challenged_by"
    t.text     "challenged"
    t.text     "video_link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bucketeers", ["identifier"], name: "index_bucketeers_on_identifier", using: :btree

  create_table "tweets", force: true do |t|
    t.string   "tweet_id"
    t.datetime "tweet_date"
    t.text     "tweet_text"
    t.string   "tweeter_id"
    t.string   "tweeter_name"
    t.string   "tweeter_screen_name"
    t.string   "tweeter_location"
    t.text     "tweeter_profile_image_url"
    t.integer  "retweet_count"
    t.integer  "favorite_count"
    t.text     "hashtags"
    t.text     "urls"
    t.text     "user_mentions"
    t.integer  "bucketeer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
