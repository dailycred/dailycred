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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121218205329) do

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.datetime "created"
  end

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "email"
    t.datetime "created",       :limit => 8
    t.string   "username"
    t.boolean  "verified"
    t.boolean  "admin"
    t.string   "referred_by"
    t.string   "token"
    t.text     "facebook"
    t.text     "tags"
    t.text     "referred"
    t.text     "google"
    t.text     "twitter"
    t.text     "github"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "display"
    t.boolean  "subscribed"
    t.text     "access_tokens"
    t.string   "access_token"
    t.text     "identities"
  end

end
