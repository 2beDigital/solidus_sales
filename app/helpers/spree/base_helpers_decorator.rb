Spree::BaseHelper.module_eval do
	def display_price(product)
		cache_key = "display-price-#{product.id}-#{product.updated_at}"
		Rails.cache.fetch("#{cache_key}/product_id", expires_in: 6.hours) do
			price = is_promotionable?(product) ? product.price * ( 100 - percentage(product,product.id) ) / 100 : product.price 
			to_money(price)
		end
	end
end