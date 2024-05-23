class AuthorizedController < ApplicationController
    before_action :set_current_account
    before_action :authorize_member

    private
    
    def set_current_account
        @current_account = Account.find(params[:account_id])
    end
    
    def authorize_member
        return redirect_to root_path, alert: 'You are not a member' unless @current_account.users.include? current_user
    end
end
