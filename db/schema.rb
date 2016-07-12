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

ActiveRecord::Schema.define(version: 20160711172324) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "documents", force: :cascade do |t|
    t.string   "attachment_id",           null: false
    t.string   "attachment_filename"
    t.integer  "attachment_size"
    t.string   "attachment_content_type"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "attachment_fingerprint"
    t.string   "attachment_name"
    t.string   "attachment_tags",                      array: true
    t.string   "attachment_pages",                     array: true
    t.tsvector "attachment_tsterms"
    t.index ["attachment_fingerprint"], name: "documents_attachment_fingerprint_idx", unique: true, using: :btree
    t.index ["attachment_tsterms"], name: "documents_attachment_tsterms_idx", using: :gin
  end

end
