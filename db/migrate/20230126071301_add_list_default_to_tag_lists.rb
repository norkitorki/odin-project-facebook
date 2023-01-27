class AddListDefaultToTagLists < ActiveRecord::Migration[7.0]
  def change
    change_column_default :tag_lists, :list, from: nil, to: ''
  end
end
