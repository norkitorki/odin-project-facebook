class AddRemotePhotoToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :remote_photo, :string
  end
end
