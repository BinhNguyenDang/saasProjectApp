class Member < ApplicationRecord
  belongs_to :user
  belongs_to :project

  # for define Admin in Members 
  def admin?
    roles["admin"] == true
  end
end
