class AddDeletedAtToModels < ActiveRecord::Migration[7.0]
  def change
    add_column :assistant_configurations, :deleted_at, :datetime
    add_column :job_leads, :deleted_at, :datetime
    add_column :job_sources, :deleted_at, :datetime
    add_column :notes, :deleted_at, :datetime
    add_column :notifiers, :deleted_at, :datetime
    add_column :users, :deleted_at, :datetime

    add_index :assistant_configurations, :deleted_at
    add_index :job_leads, :deleted_at
    add_index :job_sources, :deleted_at
    add_index :notes, :deleted_at
    add_index :notifiers, :deleted_at
    add_index :users, :deleted_at
  end
end
