class AddSettingsToJobSources < ActiveRecord::Migration[7.0]
  def change
    add_column :job_sources, :kind, :integer, default: 0
    add_column :job_sources, :refresh_rate, :integer, default: 60
    add_column :job_sources, :settings, :jsonb
  end
end
