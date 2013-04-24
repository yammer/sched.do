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

ActiveRecord::Schema.define(:version => 20130424210132) do

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
    t.string   "name",                                                    :null => false
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.integer  "user_id",                                                 :null => false
    t.string   "uuid",                    :limit => 8,                    :null => false
    t.boolean  "open",                                 :default => true
    t.integer  "winning_suggestion_id"
    t.string   "winning_suggestion_type"
    t.boolean  "time_based",                           :default => false, :null => false
  end

  add_index "events", ["name"], :name => "index_events_on_name"
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
    t.string   "email",                                 :null => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "has_ever_logged_in", :default => false, :null => false
  end

  add_index "guests", ["email"], :name => "index_guests_on_email"

  create_table "invitations", :force => true do |t|
    t.integer  "event_id",        :null => false
    t.integer  "invitee_id",      :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "invitee_type",    :null => false
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "vote_id"
    t.datetime "reminded_at"
    t.text     "invitation_text"
  end

  add_index "invitations", ["event_id"], :name => "index_invitations_on_event_id"
  add_index "invitations", ["invitee_id"], :name => "index_invitations_on_invitee_id"
  add_index "invitations", ["reminded_at"], :name => "index_invitations_on_reminded_at"
  add_index "invitations", ["sender_id"], :name => "index_invitations_on_sender_id"
  add_index "invitations", ["sender_type"], :name => "index_invitations_on_sender_type"
  add_index "invitations", ["vote_id"], :name => "index_invitations_on_vote_id"

  create_table "primary_suggestions", :force => true do |t|
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "event_id",                 :null => false
    t.string   "description",              :null => false
    t.integer  "suggestion_id_deprecated"
  end

  add_index "primary_suggestions", ["description"], :name => "index_primary_suggestions_on_description"
  add_index "primary_suggestions", ["event_id"], :name => "index_primary_suggestions_on_event_id"

  create_table "reminders", :force => true do |t|
    t.integer  "sender_id",     :null => false
    t.string   "sender_type",   :null => false
    t.integer  "receiver_id",   :null => false
    t.string   "receiver_type", :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "reminders", ["receiver_id"], :name => "index_reminders_on_receiver_id"
  add_index "reminders", ["receiver_type"], :name => "index_reminders_on_receiver_type"
  add_index "reminders", ["sender_id"], :name => "index_reminders_on_sender_id"
  add_index "reminders", ["sender_type"], :name => "index_reminders_on_sender_type"

  create_table "secondary_suggestions", :force => true do |t|
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "primary_suggestion_id",    :null => false
    t.string   "description",              :null => false
    t.integer  "suggestion_id_deprecated"
  end

  add_index "secondary_suggestions", ["description"], :name => "index_secondary_suggestions_on_description"
  add_index "secondary_suggestions", ["primary_suggestion_id"], :name => "index_secondary_suggestions_on_primary_suggestion_id"

  create_table "suggestions_deprecated", :force => true do |t|
    t.integer  "event_id",                   :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "primary",    :default => "", :null => false
    t.string   "secondary",  :default => "", :null => false
  end

  add_index "suggestions_deprecated", ["event_id"], :name => "index_suggestions_on_event_id"
  add_index "suggestions_deprecated", ["primary"], :name => "index_suggestions_on_primary"

  create_table "user_votes", :force => true do |t|
    t.integer "user_id", :null => false
  end

  add_index "user_votes", ["user_id"], :name => "index_user_votes_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name",                                              :null => false
    t.string   "encrypted_access_token"
    t.integer  "yammer_user_id",                                    :null => false
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.text     "email"
    t.text     "nickname"
    t.text     "image"
    t.text     "yammer_profile_url",                                :null => false
    t.text     "extra"
    t.boolean  "yammer_staging",                 :default => false
    t.integer  "yammer_network_id",                                 :null => false
    t.string   "watermarked_image_file_name"
    t.string   "watermarked_image_content_type"
    t.integer  "watermarked_image_file_size"
    t.datetime "watermarked_image_updated_at"
    t.string   "yammer_network_name",            :default => "",    :null => false
    t.boolean  "is_admin",                       :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["encrypted_access_token"], :name => "index_users_on_encrypted_access_token"
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["yammer_network_id"], :name => "index_users_on_yammer_network_id"
  add_index "users", ["yammer_user_id"], :name => "index_users_on_yammer_user_id"

  create_table "votes", :force => true do |t|
    t.integer  "suggestion_id_deprecated"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "voter_id",                 :null => false
    t.string   "voter_type",               :null => false
    t.integer  "suggestion_id",            :null => false
    t.string   "suggestion_type",          :null => false
    t.integer  "event_id"
  end

  add_index "votes", ["suggestion_id_deprecated"], :name => "index_votes_on_suggestion_id"
  add_index "votes", ["voter_id"], :name => "index_votes_on_votable_id"
  add_index "votes", ["voter_type"], :name => "index_votes_on_votable_type"

end
