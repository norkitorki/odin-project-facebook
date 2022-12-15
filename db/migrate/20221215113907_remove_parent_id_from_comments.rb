class RemoveParentIdFromComments < ActiveRecord::Migration[7.0]
  def change
    remove_column :comments, :parent_id, :bigint, foreign_key: true
  end
end
