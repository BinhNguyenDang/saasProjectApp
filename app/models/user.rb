class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  has_many :members
  has_many :projects, through: :members
  has_many :accounts, foreign_key: 'creator_id'


  def admin?
    # Retrieve the first member from the collection of members associated with the current object.
    member = self.members.first
    # Check if the member is present and if they have admin privileges.
    member.present? && member.admin?
  end
end
