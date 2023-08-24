class AddSettingsToJobFeeds < ActiveRecord::Migration[7.0]
  def change
    add_column :job_feeds, :kind, :integer, default: 0
    add_column :job_feeds, :refresh_rate, :integer, default: 60
    add_column :job_feeds, :settings, :jsonb
  end
end
