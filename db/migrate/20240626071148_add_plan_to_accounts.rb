class AddPlanToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :plan, :string
  end
end
