class CreateJobLeads < ActiveRecord::Migration[7.0]
  def change
    create_table :job_leads do |t|
      t.references :job_feed, null: false, foreign_key: true
      t.datetime :published_at

      t.timestamps
    end
  end
end
