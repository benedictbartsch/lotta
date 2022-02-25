class AddDatesToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :status_updated_at, :datetime
    add_column :items, :due_at, :datetime
    add_column :items, :starts_at, :datetime
    add_column :items, :ends_at, :datetime
  end
end
