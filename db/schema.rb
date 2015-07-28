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

ActiveRecord::Schema.define(version: 20150728161729) do

  create_table "cookbooks", force: :cascade do |t|
    t.string   "name"
    t.text     "desc"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "cookbooks", ["user_id"], name: "index_cookbooks_on_user_id"

  create_table "cookbooks_recipes", id: false, force: :cascade do |t|
    t.integer "cookbooks_id"
    t.integer "recipes_id"
  end

  add_index "cookbooks_recipes", ["cookbooks_id"], name: "index_cookbooks_recipes_on_cookbooks_id"
  add_index "cookbooks_recipes", ["recipes_id"], name: "index_cookbooks_recipes_on_recipes_id"

  create_table "ingredients", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.integer  "recipe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ingredients", ["recipe_id"], name: "index_ingredients_on_recipe_id"

  create_table "recipes", force: :cascade do |t|
    t.string   "name"
    t.text     "desc"
    t.string   "image"
    t.text     "prep"
    t.integer  "ingredient_id"
    t.integer  "cookbook_id"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "recipes", ["cookbook_id"], name: "index_recipes_on_cookbook_id"
  add_index "recipes", ["ingredient_id"], name: "index_recipes_on_ingredient_id"
  add_index "recipes", ["user_id"], name: "index_recipes_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
