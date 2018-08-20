Spree::Variant::PriceSelector.class_eval do

      include Sales

      def self.pricing_options_class
        Spree::Variant::PricingOptions
      end

      attr_reader :variant

      def initialize(variant)
        @variant = variant
      end

      # The variant's price, given a set of pricing options
      # @param [Spree::Variant::PricingOptions] price_options Pricing Options to abide by
      # @return [Spree::Money, nil] The most specific price for this set of pricing options.
      def price_for(price_options)
        variant.currently_valid_prices.detect do |price|
          ( price.country_iso == price_options.desired_attributes[:country_iso] ||
            price.country_iso.nil?
          ) && price.currency == price_options.desired_attributes[:currency]
          price.amount = is_promotionable?(variant) ? calculate(variant) : price.amount
        end.try!(:money)
      end

end