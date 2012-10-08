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

ActiveRecord::Schema.define(:version => 20121007075607) do

  create_table "affirmations", :force => true do |t|
    t.string   "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "habit_id"
  end

  create_table "habits", :force => true do |t|
    t.string   "statement"
    t.date     "goal_date"
    t.integer  "user_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "habit_type", :default => "kick"
    t.string   "status",     :default => "pending"
    t.date     "start_date"
    t.string   "reward"
  end

  add_index "habits", ["user_id", "created_at"], :name => "index_habits_on_user_id_and_created_at"

  create_table "reasons", :force => true do |t|
    t.string   "message"
    t.integer  "importance"
    t.integer  "habit_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "reasons", ["habit_id"], :name => "index_reasons_on_habit_id"

  create_table "steps", :force => true do |t|
    t.string   "content"
    t.integer  "habit_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "steps", ["habit_id"], :name => "index_steps_on_habit_id"

  create_table "trackers", :force => true do |t|
    t.date     "day"
    t.boolean  "success"
    t.string   "notes"
    t.integer  "habit_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "trackers", ["habit_id"], :name => "index_trackers_on_habit_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "time_zone",       :default => "Pacific Time (US & Canada)"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
