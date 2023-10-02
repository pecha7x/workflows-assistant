class AddTypeAndSettingsToAssistantConfiguration < ActiveRecord::Migration[7.0]
  #
  # since assistant_configurations this is "new" table (unused before)
  # and I would to keep :type and :settings at the begin of table
  # we just re-create the table (FYI: option "after: :column_name" is not supported by Postgres)
  #
  disable_ddl_transaction!

  def change
    drop_table :assistant_configurations do |t|
      t.references :user, null: false, foreign_key: true, index: false
      t.datetime :deleted_at

      t.timestamps
    end

    create_table :assistant_configurations do |t|
      t.string :type, null: false
      t.jsonb :settings
      t.references :user, null: false, foreign_key: true, index: false
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :assistant_configurations, %i[user_id deleted_at], algorithm: :concurrently
  end
end
