class AddCreatorIdToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :creator_id, :integer
    add_foreign_key :accounts, :users, column: :creator_id
    add_index :accounts, :creator_id
  end
end
