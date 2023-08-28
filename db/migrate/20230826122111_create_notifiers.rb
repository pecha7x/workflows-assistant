class CreateNotifiers < ActiveRecord::Migration[7.0]
  def change
    create_table :notifiers do |t|
      t.string :name, null: false
      t.integer :kind, default: 0
      t.references :owner, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.jsonb :settings

      t.timestamps
    end
  end
end
