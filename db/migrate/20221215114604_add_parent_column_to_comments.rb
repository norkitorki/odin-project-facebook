class AddParentColumnToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :parent, :string, foreign_key: true
    add_index :comments, :parent
  end
end
