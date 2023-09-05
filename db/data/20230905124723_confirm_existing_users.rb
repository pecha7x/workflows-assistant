# frozen_string_literal: true

class ConfirmExistingUsers < ActiveRecord::Migration[7.0]
  def up
    # rubocop:disable Rails/SkipsModelValidations
    User.update_all confirmed_at: Time.current
    # rubocop:enable Rails/SkipsModelValidations
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
