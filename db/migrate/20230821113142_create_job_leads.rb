class CreateJobLeads < ActiveRecord::Migration[7.0]
  def change
    create_table :job_leads do |t|
      t.string :title, null: false
      t.text :description
      t.text :link, null: false
      t.integer :potential, default: 1
      t.integer :status, default: 0
      t.decimal :hourly_rate, precision: 10, scale: 2, null: false
      t.references :job_source, null: false, foreign_key: true
      t.datetime :published_at

      t.timestamps
    end
  end
end
