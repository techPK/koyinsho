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

ActiveRecord::Schema.define(:version => 20130118020631) do

  create_table "members", :force => true do |t|
    t.string   "username"
    t.string   "email",                        :null => false
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "roles"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
  end

  add_index "members", ["remember_me_token"], :name => "index_members_on_remember_me_token"

  create_table "nyc_building_permits", :force => true do |t|
    t.string   "bin"
    t.string   "job"
    t.string   "job_type"
    t.string   "job_doc"
    t.string   "work_type"
    t.string   "permit_sequence"
    t.string   "permit_type"
    t.string   "permit_subtype"
    t.string   "permit_status"
    t.string   "filing_status"
    t.date     "filing_date"
    t.date     "issuance_date"
    t.date     "expiration_date"
    t.date     "job_start_date"
    t.string   "borough"
    t.string   "block"
    t.string   "lot"
    t.string   "community_board"
    t.string   "street_name"
    t.string   "house"
    t.string   "city_state_zip"
    t.string   "zip_code"
    t.string   "special_district_1"
    t.string   "special_district_2"
    t.string   "bldg_type"
    t.string   "residential"
    t.string   "site_fill"
    t.string   "oil_gas"
    t.string   "permittee_s_business_name"
    t.string   "permittee_s_first_last_name"
    t.string   "permittee_s_license"
    t.string   "permittee_s_license_type"
    t.string   "permittee_s_phone"
    t.string   "self_cert"
    t.string   "hic_license"
    t.string   "site_safety_mgr_s_name"
    t.string   "site_safety_mgr_business_name"
    t.string   "superintendent_first_last_name"
    t.string   "superintendent_business_name"
    t.string   "owner_s_business_name"
    t.string   "owner_s_business_type"
    t.string   "owner_s_first_last_name"
    t.string   "owner_s_house_street"
    t.string   "owner_s_phone"
    t.string   "non_profit"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "permits", :force => true do |t|
    t.string   "property_borough"
    t.string   "property_block_number"
    t.string   "property_lot_number"
    t.string   "property_community_district_number"
    t.string   "property_address_number"
    t.string   "property_street"
    t.string   "property_zipcode"
    t.string   "owner_full_name"
    t.string   "owner_business_name"
    t.string   "owner_business_kind"
    t.string   "owner_street_address"
    t.string   "owner_city_state"
    t.string   "owner_zipcode"
    t.string   "owner_phone"
    t.string   "permit_kind"
    t.string   "permit_subkind"
    t.string   "licensee_full_name"
    t.string   "licensee_business_name"
    t.string   "licensee_license_kind"
    t.string   "licensee_license_number"
    t.string   "licensee_license_HIC_number"
    t.string   "licensee_phone"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "permit_job_number"
    t.boolean  "owner_is_non_profit"
    t.date     "permit_issuance_date"
  end

end
