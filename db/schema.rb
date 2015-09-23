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

ActiveRecord::Schema.define(version: 20150915033421) do

  create_table "microposts", force: true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "microposts", ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at"

  create_table "pjmrs", force: true do |t|
    t.string   "ph"
    t.string   "txlx"
    t.string   "pjlx"
    t.string   "pch"
    t.decimal  "pmje",       precision: 16, scale: 2
    t.date     "zrrq"
    t.date     "cprq"
    t.string   "pmdqrq"
    t.integer  "jjrjt"
    t.integer  "ydjt"
    t.integer  "jxts"
    t.date     "jxdqrq"
    t.decimal  "zrll",       precision: 12, scale: 6
    t.decimal  "zrlx",       precision: 16, scale: 2
    t.decimal  "sfje",       precision: 16, scale: 2
    t.string   "khmc"
    t.string   "cpr"
    t.string   "cprkhh"
    t.string   "ckr"
    t.string   "skrkhh"
    t.string   "ckrkhh"
    t.text     "bz"
    t.string   "khjlmc"
    t.string   "dabh"
    t.string   "kczt"
    t.date     "rkrq"
    t.date     "ckrq"
    t.string   "lrr"
    t.datetime "lrsj"
    t.string   "shr"
    t.datetime "shsj"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pjmrs", ["ph", "pch"], name: "index_pjmrs_on_ph_and_pch", unique: true

  create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
