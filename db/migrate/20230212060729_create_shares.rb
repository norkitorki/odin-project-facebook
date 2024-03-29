class CreateShares < ActiveRecord::Migration[7.0]
  def change
    create_table :shares do |t|
      t.references :user, null: false, foreign_key: true
      t.string :slug, index: true
      t.references :shareable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
