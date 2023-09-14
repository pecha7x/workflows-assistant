class AddSanitizedLinksToNotifiers < ActiveRecord::Migration[7.0]
  def change
    add_column :notifiers, :sanitized_links, :boolean, null: false, default: false
  end
end
