class CreateTagLists < ActiveRecord::Migration[7.0]
  def change
    create_table :tag_lists do |t|
      t.string :list
      t.references :tagable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
