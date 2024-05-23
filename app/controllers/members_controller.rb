class MembersController < ApplicationController
    before_action :set_current_account

    def index
        @member = @current_account.members 
    end

    private 

    def set_current_account
        @current_account = Account.find(params[:account_id])
    end
end
