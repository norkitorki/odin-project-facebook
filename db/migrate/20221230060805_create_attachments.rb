class CreateAttachments < ActiveRecord::Migration[7.0]
  def up
    create_table :attachments do |t|
      t.string :photo
      t.string :remote_photo
      t.string :video
      t.string :remote_video
      t.string :slug
      t.index :slug, unique: true
      t.references :attachable, polymorphic: true, null: false

      t.timestamps
    end

    remove_column :posts, :photo
    remove_column :posts, :remote_photo
    remove_column :posts, :video
    remove_column :posts, :remote_video
  end

  def down
    drop_table :attachments

    add_column :posts, :photo, :string
    add_column :posts, :remote_photo, :string
    add_column :posts, :video, :string
    add_column :posts, :remote_video, :string
  end
end
