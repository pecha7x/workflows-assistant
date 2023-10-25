class RedesignGmailMessages < ActiveRecord::Migration[7.0]
  #
  # since gmail_messages this is "new" table (unused before)
  # and I would to keep :timestamps at the end of table
  # we just re-create the table (FYI: option "after: :column_name" is not supported by Postgres)
  #
  disable_ddl_transaction!

  def change
    drop_table :gmail_messages do |t|
      t.string :from, null: false
      t.string :subject
      t.text :body
      t.string :external_id, null: false
      t.references :user, null: false, foreign_key: true, index: false
      t.references :assistant_configuration, null: false, foreign_key: true, index: false
      t.datetime :deleted_at

      t.timestamps
    end

    create_table :gmail_messages do |t|
      t.string :from, null: false
      t.text :short_body, null: false
      t.text :raw_body, null: false
      t.string :external_id, null: false
      t.references :user, null: false, foreign_key: true, index: false
      t.references :assistant_configuration, null: false, foreign_key: true, index: false
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :gmail_messages, %i[user_id external_id deleted_at], algorithm: :concurrently
  end
end
