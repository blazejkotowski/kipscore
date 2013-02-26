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

ActiveRecord::Schema.define(:version => 20130226130748) do

  create_table "player_associations", :force => true do |t|
    t.integer  "tournament_id"
    t.integer  "player_id"
    t.integer  "position"
    t.string   "email"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "state"
    t.string   "email_code"
    t.string   "phone"
    t.string   "licence"
    t.text     "comment"
  end

  add_index "player_associations", ["email_code"], :name => "index_player_associations_on_email_code"
  add_index "player_associations", ["player_id"], :name => "index_player_assignments_on_player_id"
  add_index "player_associations", ["state"], :name => "index_player_assignments_on_state"
  add_index "player_associations", ["tournament_id"], :name => "index_player_assignments_on_tournament_id"

  create_table "players", :force => true do |t|
    t.string   "name"
    t.integer  "rank",       :default => -1
    t.boolean  "fetched",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "ranking_id"
  end

  add_index "players", ["ranking_id"], :name => "index_players_on_ranking_id"

  create_table "players_tournaments", :id => false, :force => true do |t|
    t.integer "player_id"
    t.integer "tournament_id"
  end

  create_table "rankings", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "sport_id"
  end

  add_index "rankings", ["sport_id"], :name => "index_rankings_on_sport_id"

  create_table "sports", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tournament_forms", :force => true do |t|
    t.boolean  "name",          :default => true
    t.boolean  "rank",          :default => true
    t.boolean  "phone",         :default => false
    t.boolean  "licence",       :default => false
    t.boolean  "comment",       :default => false
    t.integer  "tournament_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "tournament_forms", ["tournament_id"], :name => "index_tournament_forms_on_tournament_id"

  create_table "tournaments", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "start_date"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.text     "description"
    t.text     "json_bracket"
    t.string   "slug"
    t.boolean  "open",         :default => true
    t.text     "json_results"
    t.string   "state"
    t.integer  "sport_id"
  end

  add_index "tournaments", ["slug"], :name => "index_tournaments_on_slug"
  add_index "tournaments", ["sport_id"], :name => "index_tournaments_on_sport_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "authentication_token"
    t.string   "password_digest"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
