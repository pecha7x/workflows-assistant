class Notifier
  module Telegram
    include ActionView::RecordIdentifier

    extend ActiveSupport::Concern
    included do
      attr_accessor :skip_telegram_fields_validation

      validate :telegram_fields_presence, if: -> { telegram_kind? }
      validate :telegram_fields_not_changed, if: lambda {
        persisted? && telegram_kind? && !skip_telegram_fields_validation
      }

      before_create :telegram_username_formatted, if: -> { telegram_kind? }
      after_create :generate_telegram_start_token

      def telegram_bot_link
        telegram_link = "https://t.me/#{Rails.application.credentials.telegram.bot.name}"
        telegram_link += "?start=#{telegram_start_token}" if telegram_start_token.present?
        telegram_link
      end

      def generate_telegram_start_token
        return unless telegram_kind? && owner_id.present? && owner_type.present?

        self.skip_telegram_fields_validation = true
        self.telegram_chat_id = nil
        self.telegram_start_token = TelegramBot::StartToken.generate_token(self, expires_in: 1.hour)
        save
      end

      def telegram_bot_start!(telegram_bot_chat_id_value)
        return unless telegram_kind? && telegram_chat_id.blank?

        self.skip_telegram_fields_validation = true
        self.telegram_chat_id = telegram_bot_chat_id_value
        self.telegram_start_token = nil
        save

        broadcast_replace_to(
          :notifiers,
          target: "#{dom_id(self)}_telegram_bot_link",
          partial: 'notifiers/telegram_bot_link',
          locals: { notifier: self }
        )
      end
    end

    def telegram_fields_presence
      errors.add(:telegram_username, 'should be present!') if send(:telegram_username).blank?
    end

    def telegram_fields_not_changed
      errors.add(:settings_field, 'changes not allowed!') if will_save_change_to_settings?
    end

    def telegram_username_formatted
      self.telegram_username = telegram_username.sub(/^@/, '')
    end
  end
end
