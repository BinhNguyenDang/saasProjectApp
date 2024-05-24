class Project < ApplicationRecord
  acts_as_tenant :account
  has_many :members
  has_many :users, through: :members
end
