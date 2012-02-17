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

ActiveRecord::Schema.define(:version => 20120216154627) do

  create_table "cases", :force => true do |t|
    t.date     "decision_date"
    t.string   "country_origin"
    t.integer  "court_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "respondent"
    t.string   "claimant"
  end

  create_table "cases_issues", :id => false, :force => true do |t|
    t.integer "case_id"
    t.integer "issue_id"
  end

  create_table "cases_subjects", :id => false, :force => true do |t|
    t.integer "case_id"
    t.integer "subject_id"
  end

  create_table "courts", :force => true do |t|
    t.string   "name"
    t.integer  "jurisdiction_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "issues", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "issues", ["description"], :name => "index_issues_on_description", :unique => true

  create_table "jurisdictions", :force => true do |t|
    t.string "name", :limit => 128, :null => false
  end

  create_table "subjects", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "subjects", ["description"], :name => "index_subjects_on_description", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
