class AddParentToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :parent_id, :bigint, foreign_key: true
    add_index :comments, :parent_id
  end
end
