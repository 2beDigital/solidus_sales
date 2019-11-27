module Sales
	def percent_global_promotion
		global_promotion, percent = [], [0,'']
		Spree::Promotion.active.where(active_solidus_sales: true).each { |p| p.rules.empty? ? global_promotion << p : nil }
		global_promotion.each { |p| percent = (percent.first < get_percent(p).first) ? get_percent(p) : percent } if global_promotion.present?
		return percent
	end

	def get_percent(promotion)
		if promotion.actions.present?
			if promotion.actions.first.type != "Spree::Promotion::Actions::CreateLineItems"
				return [promotion.actions.first.calculator.preferences.values.first.to_i, promotion.actions.first.calculator.type ]
			else
				return [0,'']
			end
		else
			return [0,'']
		end
	end

	def taxons_promotion 
		taxons_promotions = Spree::Promotion::Rules::Taxon.where(promotion_id: Spree::Promotion.active.where(active_solidus_sales: true).ids)
		if taxons_promotions.present?
		  promotions = []
		  # Select a promotion with percent aplicable and list of aplicable products
		  taxons_promotions.each do |p|
		    promotions << { percent: get_percent(p.promotion), taxons: p.taxon_ids, products: get_products_for_promotion(p.taxon_ids) }
		  end   

		  # Select the best promotion for taxons with more than one promotion
		  promotions.each do |p_1|
		    promotions.each do |p_2|
		      if p_1[:percent].first < p_2[:percent].first
		         p_1[:taxons] = p_1[:taxons] - p_2[:taxons]
		         p_1[:products] = p_1[:products] - p_2[:products]
		      end
		    end
		  end
		  return promotions
		end
	end

	def products_promotion
		products_promotions = Spree::Promotion::Rules::Product.where(promotion_id: Spree::Promotion.active.where(active_solidus_sales: true).ids)
	    if products_promotions.present?
	    	promotions = []
			# Select a promotion with percent aplicable and list of aplicable products
			products_promotions.each do |p|
				promotions << { percent: get_percent(p.promotion), products: p.product_ids }
			end   

			# Select the best promotion for taxons with more than one promotion
			promotions.each do |p_1|
				promotions.each do |p_2|
				  if p_1[:percent].first < p_2[:percent].first
				     p_1[:products] = p_1[:products] - p_2[:products]
				  end
				end
			end
			return promotions
	    end
	end

	def get_products_for_promotion(taxons)
		Spree::Product.select(:id).where("spree_products.id in (select product_id from spree_products_taxons where taxon_id in (?))", taxons).map(&:id)
	end

	def to_money(price)
		Spree::Money.new(price, { currency: Spree::Store.default.try!(:default_currency).presence || Spree::Config[:currency] }).to_html if ( !price.blank? && price > 0) # conditional for show or not cost_price
	end

	def discount_taxon(promotions, id)
		if !promotions.blank? 
			percent = [0,'']
		    promotions.each do |p|
		        if p[:products].include? id
		          percent = p[:percent]
		        end
		    end
		    return percent
		else
			return [0,'']
		end 		   
	end

	def percentage(item,id)
		cache_key = "percentage-#{id}-#{item.updated_at}"
		Rails.cache.fetch("#{cache_key}/percentage", expires_in: 6.hours) do
			products_promotions = discount_taxon(products_promotion, id)
			taxons_promotions = discount_taxon(taxons_promotion, id)
			global_promotion = percent_global_promotion
			if products_promotions.first != 0 && products_promotions.first > taxons_promotions.first && products_promotions.first > global_promotion.first
				products_promotions
			elsif taxons_promotions.first != 0 && taxons_promotions.first > global_promotion.first
				taxons_promotions
			else
				global_promotion
			end
		end
	end

	def calculate(variant)
		discount = percentage(variant,variant.product_id)
		if discount.second == "Spree::Calculator::FlatRate"
			return variant.price - discount.first
		else
			return variant.price * ( 100 - discount.first ) / 100
		end
	end

	def is_promotionable?(product)
		if product.respond_to?(:promotionable)
			return product.promotionable
		else
			return Spree::Product.find_by(id: product.product_id).promotionable
		end
	end

	def get_cost_price(id, product_or_variant)  
		if percentage(product_or_variant,id).first > 0 && is_promotionable?(product_or_variant)
			cost_price = product_or_variant.price
		else
			cost_price = product_or_variant.cost_price
		end
	end

	def variant_price(variant) 
		price = is_promotionable?(variant) ? calculate(variant) : variant.price
	end

	def variant_cost_price(variant)
		variant_cost_price = get_cost_price(variant.product_id, variant)
	end

	def display_cost_price(product)   
		cost_price = get_cost_price(product.id, product)
		return content_tag(:span, to_money(cost_price), class: 'cost-price selling') if !cost_price.blank?
		nil
	end

end