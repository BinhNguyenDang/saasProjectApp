class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    set_current_tenant_by_subdomain_or_domain(:account, :subdomain, :domain)
end
