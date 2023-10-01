class RedesignOfRedundantIndexes < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    remove_index :assistant_configurations, :deleted_at, algorithm: :concurrently, if_exists: true
    remove_index :assistant_configurations, :user_id, algorithm: :concurrently, if_exists: true
    add_index :assistant_configurations, %i[user_id deleted_at], algorithm: :concurrently, if_not_exists: true

    remove_index :job_leads, :deleted_at, algorithm: :concurrently, if_exists: true
    remove_index :job_leads, :job_source_id, algorithm: :concurrently, if_exists: true
    remove_index :job_leads, column: %i[external_id job_source_id], algorithm: :concurrently, if_exists: true
    add_index :job_leads, %i[job_source_id external_id deleted_at], algorithm: :concurrently, if_not_exists: true

    remove_index :job_sources, :deleted_at, algorithm: :concurrently, if_exists: true
    remove_index :job_sources, :user_id, algorithm: :concurrently, if_exists: true
    add_index :job_sources, %i[user_id deleted_at], algorithm: :concurrently, if_not_exists: true

    remove_index :notes, :deleted_at, algorithm: :concurrently, if_exists: true
    remove_index :notes, :user_id, algorithm: :concurrently, if_exists: true
    remove_index :notes, column: %i[owner_type owner_id], algorithm: :concurrently, if_exists: true
    add_index :notes, %i[user_id deleted_at], algorithm: :concurrently, if_not_exists: true
    add_index :notes, %i[owner_type owner_id deleted_at], algorithm: :concurrently, if_not_exists: true

    remove_index :notifiers, :deleted_at, algorithm: :concurrently, if_exists: true
    remove_index :notifiers, :user_id, algorithm: :concurrently, if_exists: true
    remove_index :notifiers, column: %i[owner_type owner_id], algorithm: :concurrently, if_exists: true
    add_index :notifiers, %i[user_id deleted_at], algorithm: :concurrently, if_not_exists: true
    add_index :notifiers, %i[owner_type owner_id deleted_at], algorithm: :concurrently, if_not_exists: true
  end
end
