class AddActiveSpreeSalesToSpreePromotions < ActiveRecord::Migration
  def change
    add_column :spree_promotions, :active_spree_sales, :boolean, default: true
  end
end
