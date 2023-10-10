class AddGmailIntegrationToGmailMessages < ActiveRecord::Migration[7.0]
  def change
    add_reference :gmail_messages, :assistant_configuration, null: false, foreign_key: true
  end
end
