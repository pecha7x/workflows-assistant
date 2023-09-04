class AddOwnerCountryAndExternalIdToJobLeads < ActiveRecord::Migration[7.0]
  def change
    change_table :job_leads, bulk: true do |t|
      t.string :owner_country, null: false
      t.string :external_id, null: false
    end

    add_index :job_leads, %i[external_id job_source_id], unique: true
  end
end
