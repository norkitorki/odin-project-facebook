class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images do |t|
      t.string :photo
      t.string :remote_photo
      t.string :slug
      t.index :slug, unique: true
      t.references :imageable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
