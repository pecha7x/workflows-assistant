class AddBackgroundJobIdToJobSources < ActiveRecord::Migration[7.0]
  def change
    add_column :job_sources, :background_job_id, :string
  end
end
