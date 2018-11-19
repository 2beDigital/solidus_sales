Spree::BaseHelper.module_eval do
	def display_price(product)
		price = is_promotionable?(product) ? product.price * ( 100 - percentage(product.id) ) / 100 : product.price 
		to_money(price)
	end
end