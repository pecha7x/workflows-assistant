class AddSettingsToJobSources < ActiveRecord::Migration[7.0]
  def change
    change_table :job_sources, bulk: true do |t|
      t.integer :kind, default: 0
      t.integer :refresh_rate, default: 60
      t.jsonb :settings
    end
  end
end
