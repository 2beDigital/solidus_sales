Spree::BaseHelper.module_eval do
  def get_promotion_all_store
    ids = Spree::PromotionAction.select(:id).where(promotion_id: (Spree::Promotion.active.select(:id).where(active_spree_sales: true)), type: "Spree::Promotion::Actions::CreateAdjustment").map(&:id)
    calculators = Spree::Calculator.where(calculable_id: ids, calculable_type: "Spree::PromotionAction" )

    return 0 if calculators.blank?
    object = calculators.first

    calculators.each do |cal|
      if object.preferred_flat_percent < cal.preferred_flat_percent
        object = cal
      end
    end

    return object.preferred_flat_percent.to_i
  end

  def get_calculator(promotion_id)
    calculator = Spree::Calculator.find_by(calculable_id: (Spree::PromotionAction.select(:id).where(promotion_id: promotion_id)), calculable_type: "Spree::PromotionAction")
    
    # Return necessary to avoid errors
    return calculator.preferred_percent if calculator.respond_to?('preferred_percent') # when the promotion is applied to the line items (implemented)
    return calculator.preferred_flat_percent if calculator.respond_to?('preferred_flat_percent') # when the promotion is applied to the order (semi-implemented)
    return calculator.preferred_amount if calculator.respond_to?('preferred_amount') # when select flat rate (not implemented)
  end

  def promotion_by_taxons 
    if !Spree::Promotion.active.blank?
      promotions_by_taxons = Spree::Promotion.active.select(:id).where(id: (Spree::PromotionRule.select(:promotion_id).where(type: "Spree::Promotion::Rules::Taxon")), active_spree_sales: true).map(&:id)
      promotion_and_calculator = []

      # Select a promotion with percent aplicable and list of aplicable products
      promotions_by_taxons.each do |id|
        taxons = Spree::Promotion.active.find_by(id: id).rules.find_by(type: 'Spree::Promotion::Rules::Taxon').taxon_ids
        promotion_and_calculator << { percent: get_calculator(id), taxons: taxons, products: get_products_for_promotion(taxons) }
      end   

      # Select the best promotion for taxons with more than one promotion
      promotion_and_calculator.each do |p_1|
        promotion_and_calculator.each do |p_2|
          if p_1[:percent] < p_2[:percent]
             p_1[:taxons] = p_1[:taxons] - p_2[:taxons]
             p_1[:products] = p_1[:products] - p_2[:products]
          end
        end
      end
      return promotion_and_calculator
    end
  end

  def get_products_for_promotion(taxons)
    Spree::Product.select(:id).where("spree_products.id in (select product_id from spree_products_taxons where taxon_id in (?))", taxons).map(&:id)
  end

  def to_money(price)
    Spree::Money.new(price, { currency: current_currency }).to_html if ( !price.blank? && price > 0) # conditional for show or not cost_price
  end

  def get_percent_by_taxons(promotion, product_id)
    percent = 0
    if !promotion.blank? 
        promotion.each do |promo|
            if promo[:products].include? product_id
              percent = promo[:percent].to_i
            end
        end
    end 
    return percent   
  end

  def percentage(id)
    percent = (get_percent_by_taxons(promotion_by_taxons, id) != 0 ) ? get_percent_by_taxons(promotion_by_taxons, id) : get_promotion_all_store
  end

  def display_price(product_or_variant)
    product_price = is_promotionable?(product_or_variant) ? product_or_variant.price * (100 - percentage(product_or_variant.id))/100 : product_or_variant.price 
    to_money(product_price)
  end

  def variant_price(product_or_variant) 
    variant_price = is_promotionable?(product_or_variant) ? product_or_variant.price * (100 - percentage(product_or_variant.product_id))/100 : product_or_variant.price
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

  def variant_cost_price(product_or_variant)
    variant_cost_price = get_cost_price(product_or_variant.product_id, product_or_variant)
  end

  def display_cost_price(product_or_variant)   
    cost_price = get_cost_price(product_or_variant.id, product_or_variant)
    return content_tag(:span, to_money(cost_price), class: 'cost-price selling') if !cost_price.blank?
    nil
  end
end