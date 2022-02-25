class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :project_id
      t.integer :workspace_id

      t.timestamps
    end

    add_column :items, :group_id, :integer
  end
end
