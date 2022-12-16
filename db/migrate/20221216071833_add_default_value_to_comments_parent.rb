class AddDefaultValueToCommentsParent < ActiveRecord::Migration[7.0]
  def change
    change_column_default :comments, :parent, from: nil, to: ''
  end
end
