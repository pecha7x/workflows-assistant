class UpdateOwnerCountryDefaultToUnitedStatesJobLeads < ActiveRecord::Migration[7.0]
  def change
    change_column_default :job_leads, :owner_country, from: nil, to: 'United States'
  end
end
