class PlansController < ApplicationController
  before_action :set_account
  def edit
  end

  private

  def set_account
    @account = current_user.accounts.first
  end
end