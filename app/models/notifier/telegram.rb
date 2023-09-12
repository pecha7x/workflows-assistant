class Notifier
  module Telegram
    extend ActiveSupport::Concern

    included do
      validate :telegram_fields_presence, if: -> { telegram_kind? }
      validate :telegram_fields_not_changed, if: -> { persisted? && telegram_kind? }

      def generate_t_me_start_token
        if new_record? && telegram_kind? && owner_id.present? && owner_type.present?
          self.t_me_start_token = TelegramBot::StartToken.generate_token(self, expires_in: 1.hour)
        end
      end

      def t_me_bot_link
        t_me_link = "https://t.me/#{TelegramBot::BOT_NAME}"
        t_me_link += "?start=#{t_me_start_token}" if t_me_start_token.present?
        t_me_link
      end
    end

    def telegram_fields_presence
      settings_fields.each do |setting_field|
        errors.add(setting_field, "Value of #{setting_field} should be present!") if send(setting_field).blank?
      end
    end
  
    def telegram_fields_not_changed
      settings_fields.each do |setting_field|
        errors.add(setting_field, "Change of #{setting_field} not allowed!") if send("#{setting_field}_changed?")
      end
    end
  end
end
