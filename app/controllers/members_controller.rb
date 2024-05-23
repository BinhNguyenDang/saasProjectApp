class MembersController < ApplicationController
    before_action :set_current_account

    def index
        @member = @current_account.members 
    end

    def invite 
        email = params[:email]
        return redirect_to account_members_path(@current_account), alert: "No email provided" if email.blank?

        user = User.find_by(email:) || User.invite!({ email: }, current_user ) # current_user will be set as invited_by

        return redirect_to account_members_path(@current_account), alert: "Email invalid" unless user.valid? 

        user.members.find_or_create_by(account: @current_account, roles: {admin: false, editor: true})
        # binding.b
        redirect_to account_members_path(@current_account), notice: "#{email} invited"
    end
end
