class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.string :video
      t.string :remote_video
      t.string :slug
      t.references :videoable, polymorphic: true, null: false

      t.timestamps
    end
    add_index :videos, :slug, unique: true
  end
end
