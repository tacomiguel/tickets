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

ActiveRecord::Schema.define(version: 2021_06_08_173623) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "clients", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "phone", limit: 15
    t.integer "client_type", limit: 1, default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departaments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "status", limit: 1, default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "question_threads", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "valor"
    t.bigint "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_question_threads_on_question_id"
  end

  create_table "questions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "campo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "ticket_bitacoras", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "modelo_id"
    t.string "modelo"
    t.string "campo"
    t.string "valor"
    t.string "valor_actual"
    t.string "verbo"
    t.string "user"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ticket_issues", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "issue_id"
    t.string "cliente"
    t.string "cliente_id"
    t.string "imei"
    t.bigint "ticket_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imei"], name: "index_ticket_issues_on_imei"
    t.index ["ticket_id"], name: "index_ticket_issues_on_ticket_id"
  end

  create_table "ticket_priorities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "color", limit: 10
    t.integer "priority", limit: 1, default: 0, null: false
    t.integer "status", limit: 1, default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "alerthours", default: 1
  end

  create_table "ticket_questions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "rb_1"
    t.integer "rb_2"
    t.integer "rb_3"
    t.integer "rb_4"
    t.integer "rb_5"
    t.string "tx_1"
    t.string "tx_2"
    t.bigint "ticket_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_ticket_questions_on_ticket_id"
  end

  create_table "ticket_reasons", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "sort"
    t.integer "default", limit: 1, default: 0, null: false
    t.integer "status", limit: 1, default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ticket_sources", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ticket_statuses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "sort"
    t.integer "default", limit: 1, default: 0, null: false
    t.integer "status", limit: 1, default: 1, null: false
    t.integer "system_status", limit: 1, default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ticket_threads", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "body"
    t.integer "thread_type", limit: 1, default: 1, null: false
    t.bigint "ticket_id"
    t.string "creator_type"
    t.bigint "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_type", "creator_id"], name: "index_ticket_threads_on_creator_type_and_creator_id"
    t.index ["ticket_id"], name: "index_ticket_threads_on_ticket_id"
  end

  create_table "tickets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.binary "uuid", limit: 36, null: false
    t.string "title"
    t.bigint "client_id"
    t.bigint "ticket_priority_id"
    t.bigint "ticket_status_id"
    t.bigint "ticket_source_id"
    t.bigint "departament_id"
    t.bigint "assigned_user_id"
    t.datetime "assigned_at"
    t.datetime "closed_at"
    t.datetime "reopened_at"
    t.string "creator_type", null: false
    t.bigint "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ticket_reason_id"
    t.date "fechaticket"
    t.index ["assigned_user_id"], name: "index_tickets_on_assigned_user_id"
    t.index ["client_id"], name: "index_tickets_on_client_id"
    t.index ["creator_type", "creator_id"], name: "index_tickets_on_creator_type_and_creator_id"
    t.index ["departament_id"], name: "index_tickets_on_departament_id"
    t.index ["ticket_priority_id"], name: "index_tickets_on_ticket_priority_id"
    t.index ["ticket_reason_id"], name: "index_tickets_on_ticket_reason_id"
    t.index ["ticket_source_id"], name: "index_tickets_on_ticket_source_id"
    t.index ["ticket_status_id"], name: "index_tickets_on_ticket_status_id"
    t.index ["uuid"], name: "index_tickets_on_uuid", unique: true
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.bigint "departament_id"
    t.string "access_token"
    t.datetime "access_token_expires_at"
    t.index ["access_token"], name: "index_users_on_access_token", unique: true
    t.index ["departament_id"], name: "index_users_on_departament_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "tags", "users"
  add_foreign_key "users", "departaments"
end
