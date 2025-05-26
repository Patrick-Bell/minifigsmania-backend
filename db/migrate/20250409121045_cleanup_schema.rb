class CleanupSchema < ActiveRecord::Migration[7.2]
  def change
    # Drop the unneeded tables
    drop_table :active_storage_variant_records, if_exists: true, force: :cascade
    drop_table :active_storage_blobs, if_exists: true, force: :cascade
    drop_table :active_storage_attachments, if_exists: true, force: :cascade
    drop_table :applicants, if_exists: true
    drop_table :candidates, if_exists: true
    drop_table :jobs, if_exists: true
    drop_table :messages, if_exists: true
    drop_table :reminders, if_exists: true
  end
end
