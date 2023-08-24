module JobFeedsHelper
  def settings_field_placeholder(value)
    return 'Search keys (use ; as separator)' if value == :search_keys
    value.to_s.humanize
  end
end
