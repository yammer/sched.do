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

ActiveRecord::Schema.define(:version => 20120821234552) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "events", :force => true do |t|
    t.string   "name",                    :null => false
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "user_id",                 :null => false
    t.string   "uuid",       :limit => 8, :null => false
  end

  add_index "events", ["user_id"], :name => "index_events_on_user_id"
  add_index "events", ["uuid"], :name => "index_events_on_uuid"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "yammer_group_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "groups", ["yammer_group_id"], :name => "index_groups_on_yammer_group_id"

  create_table "guest_votes", :force => true do |t|
    t.integer "guest_id"
  end

  add_index "guest_votes", ["guest_id"], :name => "index_guest_votes_on_guest_id"

  create_table "guests", :force => true do |t|
    t.string   "name"
    t.string   "email",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "guests", ["email"], :name => "index_guests_on_email"

  create_table "invitations", :force => true do |t|
    t.integer  "event_id",     :null => false
    t.integer  "invitee_id",   :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "invitee_type", :null => false
  end

  add_index "invitations", ["event_id"], :name => "index_invitations_on_event_id"
  add_index "invitations", ["invitee_id"], :name => "index_invitations_on_invitee_id"

  create_table "suggestions", :force => true do |t|
    t.integer  "event_id",                   :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "primary",    :default => "", :null => false
    t.string   "secondary",  :default => "", :null => false
  end

  add_index "suggestions", ["event_id"], :name => "index_suggestions_on_event_id"

  create_table "user_votes", :force => true do |t|
    t.integer "user_id", :null => false
  end

  add_index "user_votes", ["user_id"], :name => "index_user_votes_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name",                                      :null => false
    t.string   "encrypted_access_token"
    t.integer  "yammer_user_id",                            :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.text     "email"
    t.text     "nickname"
    t.text     "image"
    t.text     "yammer_profile_url",                        :null => false
    t.text     "extra"
    t.boolean  "yammer_staging",         :default => false
    t.integer  "yammer_network_id",                         :null => false
  end

  add_index "users", ["encrypted_access_token"], :name => "index_users_on_encrypted_access_token"
  add_index "users", ["yammer_network_id"], :name => "index_users_on_yammer_network_id"
  add_index "users", ["yammer_user_id"], :name => "index_users_on_yammer_user_id"

  create_table "votes", :force => true do |t|
    t.integer  "suggestion_id", :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "voter_id",      :null => false
    t.string   "voter_type",    :null => false
  end

  add_index "votes", ["suggestion_id"], :name => "index_votes_on_suggestion_id"
  add_index "votes", ["voter_id"], :name => "index_votes_on_votable_id"
  add_index "votes", ["voter_type"], :name => "index_votes_on_votable_type"

end
