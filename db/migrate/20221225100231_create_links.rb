class CreateLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :links do |t|
      t.string :body
      t.references :linkable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
