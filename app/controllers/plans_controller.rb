class PlansController < ApplicationController
  before_action :set_account
  def edit
  end

  def update
    respond_to do |format|
      Account.transaction do
        if @account.update(account_params)
          if @account.plan == "premium" && @account.payment.blank?
            @payment = Payment.new({ email: account_params["email"],
              token: params[:payment]["token"],
              account: @account 
          })
            begin
              @payment.process_payment
              @payment.save
            rescue Exception => e
              flash[:error] = e.message
              @payment.destroy
              @account.plan = "premium"
              @account.save 
              redirect_to accounts_path and return
            end
          end
          format.html { redirect_to accounts_path, notice: "Plan was successfully updated"}
        else
          format.html { render :edit }
        end
      end
    end
  end

  def change 
    @account = Account.find(params[:id])
    Account.set_current_account @account.id
    session[:account_id] = Account.current_account.id
    redirect_to home_index_path, notice: "Switched to organization #{@account.name}"
  end

  private

  def set_account
    @account = current_user.accounts.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:id, :name, :plan, :subdomain, :domain)
  end

  def self.current_account_id(user_id)
    account = find_by(creator_id: user_id)
    account.present? ? account.id : nil
  end
end