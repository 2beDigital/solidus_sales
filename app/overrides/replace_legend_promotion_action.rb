Deface::Override.new(virtual_path: 'spree/admin/promotions/_actions',
					 name: 'replace_legend_promotion_action',
					 replace: 'erb[loud]:contains("plural_resource_name(Spree::PromotionAction)")',
					 text: '<%= Spree.t(:promotion_action) %>')