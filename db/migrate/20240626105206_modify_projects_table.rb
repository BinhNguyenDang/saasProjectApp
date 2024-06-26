class ModifyProjectsTable < ActiveRecord::Migration[7.1]
  def change
    # Change the column type of account_id from bigint to integer
    change_column :projects, :account_id, :integer

    # Add new columns: details and expected_completion_date
    add_column :projects, :details, :string
    add_column :projects, :expected_completion_date, :date
  end
end
