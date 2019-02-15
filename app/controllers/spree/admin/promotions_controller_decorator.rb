Spree::Admin::PromotionsController.class_eval do
	before_action :clear_cache, only: [:update]

	private

	def clear_cache
		logger.debug "      ==== SOLIDUS_SALES#CLEAR_CACHE ====    "
		Rails.cache.clear
	end

end