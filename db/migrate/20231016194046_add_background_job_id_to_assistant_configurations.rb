class AddBackgroundJobIdToAssistantConfigurations < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_column :assistant_configurations, :background_job_id, :string
    add_index :assistant_configurations,
              %i[background_job_id deleted_at],
              algorithm: :concurrently,
              name: 'index_assistant_configurations_on_bg_job_id_and_deleted_at',
              if_not_exists: true
  end
end
