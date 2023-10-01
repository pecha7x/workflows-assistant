require 'rss'
require 'open-uri'

module JobSourceProcessor
  class Upwork < Base
    ID_FROM_LINK_REGEX = /%7E(?<external_id>.*)\?source=rss/
    RATE_FROM_DESC_REGEX = %r{<b>Hourly Range</b>:(?<hourly_range>.*)\n\n}
    COUNTRY_FROM_DESC_REGEX = %r{<b>Country</b>:(?<country>.*)\n}

    delegate :rss_url, to: :job_source

    def run
      raise 'The Feed has not RSS URL' if rss_url.blank?

      URI.parse(rss_url).open do |rss|
        feed = RSS::Parser.parse(rss)
        feed.items.each do |their_lead|
          # TODO: move find_or_initialize_by logic to base class
          job_lead = job_source.job_leads.find_or_initialize_by(external_id: their_id(their_lead.link))
          next if job_lead.persisted? # skip duplicates

          job_lead.assign_attributes(attributes(their_lead))
          if job_lead.valid?
            job_lead.save
            log('Job Lead was imported')
          else
            log "#{job_source.name}. Failed to import an job lead: " \
                "errors: <#{job_lead.errors.messages}>" \
                "attributes: <#{job_lead.attributes}>; " \
                "params: <#{their_lead.inspect}>; "
          end
        end
      end
    end

    private

    # TODO: move next mapping logic to a separate class
    def attributes(their_lead)
      {
        title: their_lead.title,
        link: their_lead.link,
        published_at: their_lead.pubDate,
        description: their_lead.description,
        hourly_rate: their_hourly_rate(their_lead.description),
        owner_country: their_owner_country(their_lead.description)
      }.compact
    end

    def their_id(their_link)
      match_id_data = their_link.match(ID_FROM_LINK_REGEX)
      return nil if match_id_data.blank?

      match_id_data[:external_id].lstrip
    end

    def their_hourly_rate(their_description)
      match_range_data = their_description.match(RATE_FROM_DESC_REGEX)
      return nil if match_range_data.blank?

      max_hourly_rate_data = match_range_data[:hourly_range].match(/-\$(?<rate>\d*\.\d*)/)
      return nil if max_hourly_rate_data.blank?

      max_hourly_rate_data[:rate].lstrip.to_f
    end

    def their_owner_country(their_description)
      match_country_data = their_description.match(COUNTRY_FROM_DESC_REGEX)
      return 'US' if match_country_data.blank?

      CountriesService.alpha2_name_by_any_name(match_country_data[:country].lstrip)
    end
  end
end
