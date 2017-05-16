module Sales
	def percent_global_promotion
		global_promotion, percent = [], 0
		Spree::Promotion.active.each { |p| (p.rules.empty? && p.active_solidus_sales) ? global_promotion << p : nil }
		global_promotion.each { |p| percent = (percent < get_percent(p)) ? get_percent(p) : percent }
		return percent
	end

	def get_percent(promotion)
		return promotion.actions.first.calculator.preferences.values.first.to_i
	end

	def taxons_promotion 
		if !Spree::Promotion.active.blank?
		  taxons_promotions, promotions = [], []
		  Spree::Promotion::Rules::Taxon.all.each { |p| (p.promotion.active? && p.promotion.active_solidus_sales) ? taxons_promotions << p : nil }
		  # Select a promotion with percent aplicable and list of aplicable products
		  taxons_promotions.each do |p|
		    promotions << { percent: get_percent(p.promotion), taxons: p.taxon_ids, products: get_products_for_promotion(p.taxon_ids) }
		  end   

		  # Select the best promotion for taxons with more than one promotion
		  promotions.each do |p_1|
		    promotions.each do |p_2|
		      if p_1[:percent] < p_2[:percent]
		         p_1[:taxons] = p_1[:taxons] - p_2[:taxons]
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
		Spree::Money.new(price, { currency: current_currency }).to_html if ( !price.blank? && price > 0) # conditional for show or not cost_price
	end

	def discount_taxon(promotions, id)
		percent = 0
		if !promotions.blank? 
		    promotions.each do |p|
		        if p[:products].include? id
		          percent = p[:percent]
		        end
		    end
		end 
		return percent   
	end

	def percentage(id)
		percent = (discount_taxon(taxons_promotion, id) != 0 ) ? discount_taxon(taxons_promotion, id) : percent_global_promotion
	end

	def calculate(variant)
		return variant.price * ( 100 - percentage(variant.product_id) ) / 100
	end

	def is_promotionable?(product)
		if product.respond_to?(:promotionable)
			return product.promotionable
		else
			return Spree::Product.find_by(id: product.product_id).promotionable
		end
	end

	def get_cost_price(id, product_or_variant)  
		if percentage(id) > 0 && is_promotionable?(product_or_variant)
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