class RegistrationsController < Devise::RegistrationsController
    def create
      build_resource(sign_up_params)
  
      resource.class.transaction do
        resource.save
        yield resource if block_given?
  
        if resource.persisted?
          create_payment_and_account(resource)
  
          if resource.active_for_authentication?
            set_flash_message :notice, :signed_up if is_flashing_format?
            sign_up(resource_name, resource)
            respond_with resource, location: after_sign_up_path_for(resource)
          else
            set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
            expire_data_after_sign_in!
            respond_with resource, location: after_inactive_sign_up_path_for(resource)
          end
        else
          clean_up_passwords resource
          set_minimum_password_length
          respond_with resource
        end
      end
    end
  
    private
  
    def create_payment_and_account(user)
      Payment.transaction do
        account = user.accounts.first || create_default_account(user)
  
        user_payment = Payment.new(
          email: user.email,
          token: params[:payment]["token"],
          account_id: account.id
        )
  
        flash[:error] = "Please check registration errors" unless user_payment.valid?
  
        begin
          # Stripe payment processing code
          intent = Stripe::PaymentIntent.create(
            amount: 1000, # Replace with your desired amount in cents
            currency: 'usd',
            description: 'Premium Membership',
            confirmation_method: 'automatic',
            payment_method: 'pm_card_visa' # Change to dynamically selected payment method
          )
  
          intent.capture if intent.status == 'succeeded'
          user_payment.save!
        rescue Stripe::StripeError => e
          handle_stripe_error(e, user)
        rescue => e
          handle_other_error(e, user)
        end
      end
    end
  
    def create_default_account(user)
      account = Account.create!(
        name: params[:account][:name],
        subdomain: params[:account][:subdomain],
        domain: params[:account][:domain],
        creator: user,
        plan: params[:account][:plan]
        )
      user.reload # Reload user to ensure association is loaded
      account
    end
  
    def handle_stripe_error(error, user)
      Rails.logger.error "Stripe Error: #{error.message}"
      flash[:error] = "Payment failed: #{error.message}"
      user.destroy
      render :new and return
    end
  
    def handle_other_error(error, user)
      Rails.logger.error "Payment Processing Error: #{error.message}"
      flash[:error] = "An unexpected error occurred during registration"
      user.destroy
      render :new and return
    end
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:payment])
    end
  end