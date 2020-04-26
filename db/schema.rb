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

ActiveRecord::Schema.define(version: 2019_12_12_125548) do

  create_table "answers", force: :cascade do |t|
    t.string "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "question_id"
    t.index ["question_id", "created_at"], name: "index_answers_on_question_id_and_created_at"
  end

  create_table "microposts", force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.index ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_microposts_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "question"
    t.integer "right_answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "test_id"
    t.index ["test_id", "created_at"], name: "index_questions_on_test_id_and_created_at"
  end

  create_table "results", force: :cascade do |t|
    t.integer "test_id"
    t.integer "user_id"
    t.text "results", default: "--- []\n"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "attempt_count", default: 3
    t.integer "pass_time", default: 20
    t.index ["test_id", "user_id"], name: "index_results_on_test_id_and_user_id", unique: true
    t.index ["test_id"], name: "index_results_on_test_id"
    t.index ["user_id"], name: "index_results_on_user_id"
  end

  create_table "talking_stick_participants", force: :cascade do |t|
    t.string "name"
    t.string "ip"
    t.string "guid"
    t.datetime "joined_at"
    t.datetime "last_seen"
    t.integer "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid"], name: "index_talking_stick_participants_on_guid"
    t.index ["room_id"], name: "index_talking_stick_participants_on_room_id"
  end

  create_table "talking_stick_rooms", force: :cascade do |t|
    t.string "name"
    t.datetime "last_used"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
  end

  create_table "talking_stick_signals", force: :cascade do |t|
    t.integer "room_id"
    t.integer "sender_id"
    t.integer "recipient_id"
    t.string "signal_type"
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id"], name: "index_talking_stick_signals_on_recipient_id"
    t.index ["room_id"], name: "index_talking_stick_signals_on_room_id"
    t.index ["sender_id"], name: "index_talking_stick_signals_on_sender_id"
  end

  create_table "tests", force: :cascade do |t|
    t.string "name"
    t.string "theme"
    t.string "subtheme"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tests_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
