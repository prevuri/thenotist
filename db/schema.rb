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
ActiveRecord::Schema.define(:version => 20130707154418) do
  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "uploaded_file_id"
    t.integer  "user_id"
    t.text     "text"
    t.decimal  "ycoord"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "contributors", :force => true do |t|
    t.integer  "user_id"
    t.integer  "shared_note_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "contributors", ["user_id"], :name => "index_contributors_on_user_id"

  create_table "notes", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "description"
    t.integer  "course_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "buddy_id"
    t.boolean  "blocked"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["buddy_id"], :name => "index_relationships_on_buddy_id"
  add_index "relationships", ["follower_id", "buddy_id"], :name => "index_relationships_on_user_id_and_buddy_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_user_id"

  create_table "uploaded_files", :force => true do |t|
    t.integer  "note_id"
    t.integer  "page_number"
    t.integer  "height"
    t.integer  "width"
    t.string   "public_path"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "thumb_url"
  end

  create_table "user_fb_data", :force => true do |t|
    t.integer  "user_id"
    t.string   "uid"
    t.string   "profile_image"
    t.string   "link"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "fb_access_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
