class ApplicationController < ActionController::Base
    # Ensures that the user is authenticated before accessing any action in the application
    before_action :authenticate_user!
    
    # Sets the current tenant based on the subdomain or domain from the request
    # This is part of the acts_as_tenant gem configuration
    set_current_tenant_by_subdomain_or_domain(:account, :subdomain, :domain)
  end
  