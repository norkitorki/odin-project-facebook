class RemovePendingAndAddMessageToFriendRequests < ActiveRecord::Migration[7.0]
  def change
    remove_column :friend_requests, :pending
    add_column :friend_requests, :message, :string
  end
end
