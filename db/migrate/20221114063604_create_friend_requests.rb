class CreateFriendRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :friend_requests do |t|
      t.boolean :pending, default: true
      t.references :user, null: false, foreign_key: true
      t.bigint :candidate_id, null: false, foreign_key: true
      t.index :candidate_id

      t.timestamps
    end
  end
end
