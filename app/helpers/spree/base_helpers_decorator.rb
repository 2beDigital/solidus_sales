Spree::BaseHelper.module_eval do
	def display_price(product)
		cache_key = "display-price-#{product.id}-#{product.updated_at}"
		Rails.cache.fetch("#{cache_key}/product_id", expires_in: 6.hours) do
			discount = percentage(product,product.id)
			if discount.second == "Spree::Calculator::FlatRate"
				price = is_promotionable?(product) ? product.price - discount.first : product.price 
			else
				price = is_promotionable?(product) ? product.price * ( 100 - discount.first ) / 100 : product.price 
			end
			to_money(price)
		end
	end
end