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

ActiveRecord::Schema.define(:version => 20120805200345) do

  create_table "aliases", :force => true do |t|
    t.integer  "keyword_id"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "case_searches", :force => true do |t|
    t.string   "name"
    t.string   "free_text"
    t.date     "date_from"
    t.date     "date_to"
    t.string   "case_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "case_searches_child_topics", :id => false, :force => true do |t|
    t.integer "case_search_id"
    t.integer "child_topic_id"
  end

  create_table "case_searches_country_origins", :id => false, :force => true do |t|
    t.integer "case_search_id"
    t.integer "country_origin_id"
  end

  create_table "case_searches_courts", :id => false, :force => true do |t|
    t.integer "case_search_id"
    t.integer "court_id"
  end

  create_table "case_searches_jurisdictions", :id => false, :force => true do |t|
    t.integer "case_search_id"
    t.integer "jurisdiction_id"
  end

  create_table "case_searches_keywords", :id => false, :force => true do |t|
    t.integer "case_search_id"
    t.integer "keyword_id"
  end

  create_table "case_searches_process_topics", :id => false, :force => true do |t|
    t.integer "case_search_id"
    t.integer "process_topic_id"
  end

  create_table "case_searches_refugee_topics", :id => false, :force => true do |t|
    t.integer "case_search_id"
    t.integer "refugee_topic_id"
  end

  create_table "cases", :force => true do |t|
    t.date     "decision_date"
    t.integer  "court_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "respondent"
    t.string   "claimant"
    t.text     "fulltext"
    t.integer  "country_origin_id"
  end

  create_table "cases_child_topics", :id => false, :force => true do |t|
    t.integer "case_id"
    t.integer "child_topic_id"
  end

  create_table "cases_keywords", :id => false, :force => true do |t|
    t.integer "case_id"
    t.integer "keyword_id"
  end

  create_table "cases_process_topics", :id => false, :force => true do |t|
    t.integer "case_id"
    t.integer "process_topic_id"
  end

  create_table "cases_refugee_topics", :id => false, :force => true do |t|
    t.integer "case_id"
    t.integer "refugee_topic_id"
  end

  create_table "cases_users", :id => false, :force => true do |t|
    t.integer "case_id"
    t.integer "user_id"
  end

  create_table "child_links", :force => true do |t|
    t.integer  "child_topic_id"
    t.integer  "keyword_id"
    t.boolean  "required"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "child_links", ["child_topic_id", "keyword_id"], :name => "index_child_links_on_child_topic_id_and_keyword_id", :unique => true
  add_index "child_links", ["child_topic_id"], :name => "index_child_links_on_child_topic_id"
  add_index "child_links", ["keyword_id"], :name => "index_child_links_on_keyword_id"

  create_table "child_topics", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "child_topics", ["description"], :name => "index_subjects_on_description", :unique => true

  create_table "country_origins", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "courts", :force => true do |t|
    t.string   "name"
    t.integer  "jurisdiction_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "jurisdictions", :force => true do |t|
    t.string "name", :limit => 128, :null => false
  end

  create_table "keywords", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "process_links", :force => true do |t|
    t.integer  "process_topic_id"
    t.integer  "keyword_id"
    t.boolean  "required"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "process_links", ["keyword_id"], :name => "index_process_links_on_keyword_id"
  add_index "process_links", ["process_topic_id", "keyword_id"], :name => "index_process_links_on_process_topic_id_and_keyword_id", :unique => true
  add_index "process_links", ["process_topic_id"], :name => "index_process_links_on_process_topic_id"

  create_table "process_topics", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "refugee_links", :force => true do |t|
    t.integer  "refugee_topic_id"
    t.integer  "keyword_id"
    t.boolean  "required"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "refugee_links", ["keyword_id"], :name => "index_refugee_links_on_keyword_id"
  add_index "refugee_links", ["refugee_topic_id", "keyword_id"], :name => "index_refugee_links_on_refugee_topic_id_and_keyword_id", :unique => true
  add_index "refugee_links", ["refugee_topic_id"], :name => "index_refugee_links_on_refugee_topic_id"

  create_table "refugee_topics", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "refugee_topics", ["description"], :name => "index_issues_on_description", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.integer  "user_type",       :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
