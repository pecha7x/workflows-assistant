class AddOwnerCountryAndExternalIdToJobLeads < ActiveRecord::Migration[7.0]
  def change
    add_column :job_leads, :owner_country, :string, null: false
    add_column :job_leads, :external_id, :string, null: false

    add_index :job_leads, [:external_id, :job_feed_id], unique: true
  end
end
