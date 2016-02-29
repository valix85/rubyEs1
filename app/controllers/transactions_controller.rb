class TransactionsController < ApplicationController
Stripe.verify_ssl_certs = false
	def create
		content = Content.find_by!(slug: params[:slug])
		token = params[:stripeToken]

		begin
			charge = Stripe::Charge.create(
			    :card    	 => token,
			    :amount      => (content.price*100).floor,
			    :description => current_user.email,
			    :currency    => 'eur'
			  )

			@sale = content.sales.create!(email_acquirente: current_user.email)
			redirect_to pickup_url(guid: @sale.guid)

		rescue Stripe::CardError => e
			@error = e
			redirect_to content_path(content), notice: @error
		end	
	end
	
	def pickup
		@sale = Sale.find_by!(guid: params[:guid])
		@content = @sale.content
	end	


end