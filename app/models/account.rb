class Account < ApplicationRecord
    # Ensure the uniqueness of the name, domain, and subdomain fields.
    # This means no two accounts can have the same value for these attributes.
    validates_uniqueness_of :name, :domain, :subdomain
  
    # Ensure the presence of the domain and subdomain fields.
    # This means these fields cannot be nil or empty when an account is created or updated.
    validates_presence_of :domain, :subdomain
  
    # Set up an association with the User model.
    # This indicates that each Account record belongs to a creator, who is a User.
    # The association uses the creator_id column in the accounts table to find the corresponding user.
    belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
    has_many :projects, dependent: :destroy
  end
  