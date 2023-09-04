# frozen_string_literal: true

class UpdateJobLeadOwnerCountryToIso3166 < ActiveRecord::Migration[7.0]
  def up
    JobLead.find_each do |job_lead|
      new_country_value = CountriesService.alpha2_name_by_any_name(job_lead.owner_country)
      job_lead.update(owner_country: new_country_value || 'US')
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
