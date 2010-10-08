# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100907164830) do

  create_table "changelogs", :force => true do |t|
    t.string   "user"
    t.string   "text"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_feedbacks", :force => true do |t|
    t.string   "name"
    t.string   "organization"
    t.string   "phone"
    t.string   "email"
    t.text     "feedback"
    t.string   "be_contacted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date_submitted"
    t.integer  "site_id"
  end

  create_table "du_users", :force => true do |t|
    t.integer  "account_id"
    t.string   "account"
    t.string   "account_url_name"
    t.string   "persistence_token", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
  end

  create_table "enews_signups", :force => true do |t|
    t.datetime "date_submitted"
    t.integer  "site_id"
    t.string   "name"
    t.string   "title"
    t.string   "organization"
    t.string   "phone"
    t.string   "email"
    t.boolean  "currently_a_customer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "free_trial_requests", :force => true do |t|
    t.string   "name"
    t.string   "company_name"
    t.string   "city"
    t.string   "zip"
    t.string   "phone"
    t.string   "number_of_employees"
    t.string   "title"
    t.string   "street_address"
    t.string   "state"
    t.string   "country"
    t.string   "email_address"
    t.string   "how_did_you_hear_about_us"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
    t.datetime "date_submitted"
  end

  create_table "mail_list_recipients", :force => true do |t|
    t.integer  "mail_list_id"
    t.integer  "site_id"
    t.string   "email_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mail_lists", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "expanded_name"
    t.string   "path"
  end

  create_table "mail_lists_sites", :id => false, :force => true do |t|
    t.integer "mail_list_id"
    t.integer "site_id"
  end

  create_table "news_items", :force => true do |t|
    t.string   "title"
    t.text     "summary"
    t.string   "link"
    t.date     "date"
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "priority",   :default => 5
  end

  create_table "news_items_sites", :id => false, :force => true do |t|
    t.integer "news_item_id"
    t.integer "site_id"
  end

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages_sites", :force => true do |t|
    t.integer  "site_id"
    t.integer  "page_id"
    t.integer  "page_source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "protected",      :default => false
  end

  create_table "reg_updates", :force => true do |t|
    t.string   "title"
    t.text     "summary"
    t.date     "date"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "site_site_vars", :force => true do |t|
    t.integer  "site_id"
    t.integer  "site_var_id"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_vars", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "official_name"
    t.string   "url"
    t.string   "layout"
    t.string   "asset_folder",  :default => ""
  end

  create_table "user_roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                               :null => false
    t.string   "login",                              :null => false
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_role_id"
  end

end
