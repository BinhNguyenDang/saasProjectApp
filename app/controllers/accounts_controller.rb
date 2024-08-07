class AccountsController < ApplicationController
  # Set the @account instance variable for show, edit, update, and destroy actions
  before_action :set_account, only: %i[ show edit update destroy ]

  # GET /accounts or /accounts.json
  # Retrieve all accounts associated with the current user
  def index
    @accounts = current_user.accounts
  end

  # GET /accounts/1 or /accounts/1.json
  # Display details of a specific account
  def show
  end

  # GET /accounts/new
  # Initialize a new Account object for the form
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  # Retrieve an account for editing
  def edit
  end

  # POST /accounts or /accounts.json
  # Create a new account with the provided parameters
  def create
    @account = Account.new(account_params)
    @account.creator_id = current_user.id # Assign current user's ID as creator_id

    respond_to do |format|
      if @account.save
        format.html { redirect_to account_url(@account), notice: "Account was successfully created." }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1 or /accounts/1.json
  # Update an existing account with the provided parameters
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to account_url(@account), notice: "Account was successfully updated." }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1 or /accounts/1.json
  # Delete an account
  def destroy
    ActsAsTenant.without_tenant do
      @account.destroy!

      respond_to do |format|
        format.html { redirect_to accounts_url, noticce: "Account was successfully destroyed."} 
        format.json { head :no_content }
      end
    end
  end

  private

    # Set the @account instance variable based on the ID in the params
    def set_account
      @account = Account.find(params[:id])
    end

    # Only allow a list of trusted parameters through to prevent mass assignment vulnerabilities
    def account_params
      params.require(:account).permit(:name, :subdomain, :domain)
    end
end
