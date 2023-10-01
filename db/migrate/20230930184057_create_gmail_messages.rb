class CreateGmailMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :gmail_messages do |t|
      t.string :from, null: false
      t.string :subject
      t.text :body
      t.string :external_id, null: false
      t.references :user, null: false, foreign_key: true, index: false
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :gmail_messages, %i[user_id external_id deleted_at], unique: true
  end
end
