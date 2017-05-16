class AddActiveSolidusSalesToSpreePromotions < ActiveRecord::Migration
  def change
    add_column :spree_promotions, :active_solidus_sales, :boolean, default: true
  end
end
