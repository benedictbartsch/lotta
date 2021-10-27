class InitSchema < ActiveRecord::Migration[6.1]
  def up
    create_table "items" do |t|
      t.text "content"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.integer "item_type", default: 0, null: false
      t.integer "status", default: 0, null: false
      t.integer "project_id"
      t.integer "workspace_id"
      t.index ["project_id"], name: "index_items_on_project_id"
      t.index ["workspace_id"], name: "index_items_on_workspace_id"
    end
    create_table "passwordless_sessions" do |t|
      t.string "authenticatable_type"
      t.integer "authenticatable_id"
      t.datetime "timeout_at", null: false
      t.datetime "expires_at", null: false
      t.datetime "claimed_at"
      t.text "user_agent", null: false
      t.string "remote_addr", null: false
      t.string "token", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["authenticatable_type", "authenticatable_id"], name: "authenticatable"
    end
    create_table "projects" do |t|
      t.string "name"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.integer "workspace_id"
      t.integer "items_count"
      t.index ["workspace_id"], name: "index_projects_on_workspace_id"
    end
    create_table "taggings" do |t|
      t.integer "tag_id"
      t.string "taggable_type"
      t.integer "taggable_id"
      t.string "tagger_type"
      t.integer "tagger_id"
      t.string "context", limit: 128
      t.datetime "created_at"
      t.string "tenant", limit: 128
      t.index ["context"], name: "index_taggings_on_context"
      t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
      t.index ["tag_id"], name: "index_taggings_on_tag_id"
      t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
      t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
      t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
      t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
      t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
      t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
      t.index ["tenant"], name: "index_taggings_on_tenant"
    end
    create_table "tags" do |t|
      t.string "name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer "taggings_count", default: 0
      t.index ["name"], name: "index_tags_on_name", unique: true
    end
    create_table "users" do |t|
      t.string "email"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.json "data"
    end
    create_table "workspaces" do |t|
      t.integer "user_id"
      t.string "name"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.json "data"
      t.index ["user_id"], name: "index_workspaces_on_user_id"
    end
    add_foreign_key "items", "projects"
    add_foreign_key "items", "workspaces"
    add_foreign_key "projects", "workspaces"
    add_foreign_key "taggings", "tags"
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The initial migration is not revertable"
  end
end
