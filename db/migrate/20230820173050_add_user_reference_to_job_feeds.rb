class AddUserReferenceToJobFeeds < ActiveRecord::Migration[7.0]
  def change
    add_reference :job_feeds, :user, null: false, foreign_key: true
  end
end
