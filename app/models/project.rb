class Project < ApplicationRecord
  # This line sets up multi-tenancy for the Project model,
  # associating each project with a specific account (tenant).
  acts_as_tenant :account
  
  # Each project belongs to an account.
  belongs_to :account

  # Virtual attribute 'plan' is used within the model but not stored in the database.
  attr_accessor :plan
  
  # Ensures that the project name is unique within the scope of its account,
  # but only if the project's name has been changed.
  validates_uniqueness_of :name, scope: :account_id, if: :name_changed? # scope use for mantain uniqueness only in tenant
  
  # Custom validation to ensure accounts with a free plan can only create one project.
  validate :free_plan_can_only_have_one_project, on: :create

  # A project can have many members, and if a project is deleted,
  # its associated members are also deleted.
  has_many :members, dependent: :destroy
  
  # Sets up a many-to-many relationship between projects and users
  # through the members join table.
  has_many :users, through: :members

  has_many :artifacts, dependent: :destroy

  # Custom validation method to enforce the rule that free plan accounts
  # can only have one project.
  def free_plan_can_only_have_one_project
    if account.plan == 'free' && account.projects.count >= 1 && !premium_plan?
      errors.add(:base, "Free plan can only have one project")
    end
  end

  # TODO 
  # Add project show limit if plan is free
  def premium_plan?
    account.plan == 'premium'
  end
end
