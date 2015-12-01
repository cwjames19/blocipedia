require 'amount'

class ChargesController < ApplicationController
	
	def new
		@stripe_btn_data = {
			key: "#{Rails.configuration.stripe[:publishable_key]}",
			description: "Blocipedia Premium Monthly Membership - #{current_user.username}",
			amount: Amount.default
		}
	end
	
	def create
		customer = Stripe::Customer.create(
			email: current_user.email,
			card: params[:stripeToken]
		)
		
		charge = Stripe::Charge.create(
			customer: customer.id,
			amount: Amount.default,
			description: "Blocipedia Premium Monthly Membership - #{current_user.email}",
			currency: 'usd'
			)
		
		current_user.premium!
		current_user.update_upgraded_at(Time.current)
		flash[:notice] = "Payment received. Enjoy the site's Premium features!"
		redirect_to edit_user_registration_path(current_user)
	
		rescue Stripe::CardError => e
			flash[:error] = e.message
			redirect_to new_charge_path
		end

end