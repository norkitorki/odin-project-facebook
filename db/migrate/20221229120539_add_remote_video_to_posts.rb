class AddRemoteVideoToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :remote_video, :string
  end
end
