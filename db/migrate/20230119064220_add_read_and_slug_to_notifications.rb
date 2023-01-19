class AddReadAndSlugToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :read, :boolean, default: false
    add_column :notifications, :slug, :string
    add_index  :notifications, :slug, unique: true
  end
end
