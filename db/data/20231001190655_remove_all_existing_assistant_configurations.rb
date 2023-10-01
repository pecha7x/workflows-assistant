# frozen_string_literal: true

class RemoveAllExistingAssistantConfigurations < ActiveRecord::Migration[7.0]
  def up
    AssistantConfiguration.delete_all!
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
