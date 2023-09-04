class CountriesService
  def self.alpha2_name_by_any_name(value)
    country_info = ISO3166::Country.find_country_by_any_name(value)
    country_info && country_info.data['alpha2']
  end
end
