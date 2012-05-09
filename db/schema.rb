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

ActiveRecord::Schema.define(:version => 20120509064849) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.string   "lang_code"
    t.string   "image_uri"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.text     "images"
    t.integer  "creator_id"
    t.integer  "last_modifier_id"
  end

  create_table "authors", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "information_versions", :force => true do |t|
    t.integer  "information_id"
    t.text     "content"
    t.datetime "until"
    t.integer  "author_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "informations", :force => true do |t|
    t.integer  "article_id"
    t.text     "content"
    t.integer  "score"
    t.integer  "last_revision_author_id"
    t.boolean  "is_main",                 :default => false
    t.string   "link_for_details"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.boolean  "deleted",                 :default => false
  end

end
