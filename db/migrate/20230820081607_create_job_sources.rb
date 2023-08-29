class CreateJobSources < ActiveRecord::Migration[7.0]
  def change
    create_table :job_sources do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
