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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_160_925_081_554) do
  create_table 'search_conditions', force: :cascade do |t|
    t.string   'name',         limit: 255
    t.text     'query_string', limit: 65_535, null: false
    t.boolean  'save_flag',                  default: false, null: false
    t.integer  'view_number',  limit: 4,     default: 0,     null: false
    t.integer  'user_id',      limit: 4,                     null: false
    t.datetime 'created_at',                                 null: false
    t.datetime 'updated_at',                                 null: false
  end

  add_index 'search_conditions', ['user_id'], name: 'index_search_conditions_on_user_id', using: :btree
  add_index 'search_conditions', ['view_number'], name: 'index_search_conditions_on_view_number', using: :btree

  create_table 'sequels', force: :cascade do |t|
    t.text     'content',     limit: 65_535
    t.integer  'view_number', limit: 4, default: 0, null: false
    t.integer  'tale_id',     limit: 4
    t.datetime 'created_at',                            null: false
    t.datetime 'updated_at',                            null: false
  end

  add_index 'sequels', ['tale_id'], name: 'index_sequels_on_tale_id', using: :btree
  add_index 'sequels', %w(view_number tale_id), name: 'index_sequels_on_view_number_and_tale_id', unique: true, using: :btree
  add_index 'sequels', ['view_number'], name: 'index_sequels_on_view_number', using: :btree

  create_table 'tags', force: :cascade do |t|
    t.string   'name',        limit: 255
    t.integer  'view_number', limit: 4, default: 0, null: false
    t.integer  'user_id',     limit: 4,               null: false
    t.datetime 'created_at',                          null: false
    t.datetime 'updated_at',                          null: false
  end

  add_index 'tags', %w(name user_id), name: 'index_tags_on_name_and_user_id', unique: true, using: :btree
  add_index 'tags', ['user_id'], name: 'index_tags_on_user_id', using: :btree
  add_index 'tags', %w(view_number user_id), name: 'index_tags_on_view_number_and_user_id', unique: true, using: :btree
  add_index 'tags', ['view_number'], name: 'index_tags_on_view_number', using: :btree

  create_table 'tale_tag_relationships', force: :cascade do |t|
    t.integer 'tale_id', limit: 4
    t.integer 'tag_id',  limit: 4
  end

  add_index 'tale_tag_relationships', ['tag_id'], name: 'index_tale_tag_relationships_on_tag_id', using: :btree
  add_index 'tale_tag_relationships', %w(tale_id tag_id), name: 'index_tale_tag_relationships_on_tale_id_and_tag_id', unique: true, using: :btree
  add_index 'tale_tag_relationships', ['tale_id'], name: 'index_tale_tag_relationships_on_tale_id', using: :btree

  create_table 'tales', force: :cascade do |t|
    t.string   'title',       limit: 255, null: false
    t.text     'content',     limit: 65_535, null: false
    t.integer  'view_number', limit: 4, default: 0, null: false
    t.integer  'user_id',     limit: 4,                 null: false
    t.datetime 'created_at',                            null: false
    t.datetime 'updated_at',                            null: false
  end

  add_index 'tales', ['user_id'], name: 'index_tales_on_user_id', using: :btree
  add_index 'tales', %w(view_number user_id), name: 'index_tales_on_view_number_and_user_id', unique: true, using: :btree
  add_index 'tales', ['view_number'], name: 'index_tales_on_view_number', using: :btree

  create_table 'users', force: :cascade do |t|
    t.string   'email',                  limit: 255, default: '', null: false
    t.string   'encrypted_password',     limit: 255, default: '', null: false
    t.string   'reset_password_token',   limit: 255
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer  'sign_in_count', limit: 4, default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string   'current_sign_in_ip',     limit: 255
    t.string   'last_sign_in_ip',        limit: 255
    t.datetime 'created_at',                                      null: false
    t.datetime 'updated_at',                                      null: false
    t.string   'name', limit: 255, default: '', null: false
  end

  add_index 'users', ['email'], name: 'index_users_on_email', unique: true, using: :btree
  add_index 'users', ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true, using: :btree

  add_foreign_key 'search_conditions', 'users'
  add_foreign_key 'sequels', 'tales'
  add_foreign_key 'tags', 'users'
  add_foreign_key 'tale_tag_relationships', 'tags'
  add_foreign_key 'tale_tag_relationships', 'tales'
  add_foreign_key 'tales', 'users'
end
