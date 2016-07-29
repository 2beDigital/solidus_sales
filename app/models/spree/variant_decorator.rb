Spree::Variant.class_eval do

  include ActionView::Helpers::NumberHelper
  include Spree::BaseHelper

  def to_hash
    actual_price  = variant_price(self)
    actual_cost_price = variant_cost_price(self)
    #actual_price += Calculator::Vat.calculate_tax_on(self) if Spree::Config[:show_price_inc_vat]
    {
      :id    => self.id,
      :in_stock => self.in_stock?,
      :can_supply => self.can_supply?,
      :price => number_to_currency(actual_price),
      :cost_price => number_to_currency(actual_cost_price)
    }
  end

end