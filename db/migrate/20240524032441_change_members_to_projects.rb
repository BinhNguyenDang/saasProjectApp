class ChangeMembersToProjects < ActiveRecord::Migration[7.1]
  def change
    remove_reference :members, :account, foreign_key: true
    add_reference :members, :project, null: false, foreign_key: true
  end
end
