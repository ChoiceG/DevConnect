class AddAvatarToProfiles < ActiveRecord::Migration[8.0]
  def change
    add_reference :profiles, :avatar, foreign_key: { to_table: :active_storage_attachments }
  end
end
