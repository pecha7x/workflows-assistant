class AddBackgroundJobIdToJobFeeds < ActiveRecord::Migration[7.0]
  def change
    add_column :job_feeds, :background_job_id, :string
  end
end
